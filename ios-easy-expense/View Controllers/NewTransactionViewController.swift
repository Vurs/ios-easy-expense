//
//  NewTransactionViewController.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-05.
//

import UIKit
import CoreHaptics
import Vision
import AVFoundation

class NewTransactionViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    var selectedImage: UIImage?
    
    @IBOutlet var ttSegControl : UISegmentedControl!
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var recurringSlider : UISwitch!
    @IBOutlet var amtTransactedTextField : UITextField!
    @IBOutlet var saveBtn : UIButton!
    
    var hapticEngine: CHHapticEngine!
    var supportsHaptics: Bool = false
    
    var soundPlayer : AVAudioPlayer?
    
    func readTextFromImage(image: UIImage) -> String? {
        guard let cgImage = image.cgImage else {
            print("Error: Could not convert UIImage to CGImage")
            return nil
        }
        
        var recognizedText: String?
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("Error: Could not get recognized text observations")
                return
            }
            
            recognizedText = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
        })
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error: \(error)")
        }
        
        return recognizedText
    }
    
    func determineTotalAlgo(ocrText: String) -> String {
        let lines = ocrText.components(separatedBy: "\n")
        
        var totalPrice = 0.0
        var totalString = "0.0"
        
        for i in 0..<lines.count {
            if lines[i].uppercased() == "TOTAL" {
                for x in (i + 1)..<lines.count {
                    if let total = Double(lines[x]) {
                        totalPrice = total
                        break
                    } else {
                        let substring = String(lines[x].dropFirst())
                        if let total = Double(substring) {
                            totalPrice = total
                            break
                        }
                    }
                }
            }
        }
        
        if totalPrice == 0.0 {
            print("Could not find the total!")
        } else {
            totalString = String(format: "%.2f", totalPrice)
        }
        
        return totalString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Check if the device supports haptics.
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
        
        if supportsHaptics == true {
            do {
                hapticEngine = try CHHapticEngine()
                try hapticEngine.start()
            } catch {
                print("Error starting haptic engine: \(error.localizedDescription)")
            }
        }
        
        // Setup AV
        guard let soundURL = Bundle.main.path(forResource: "Cash-Register-Audio", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: soundURL)
        do {
            self.soundPlayer = try AVAudioPlayer(contentsOf: url)
            self.soundPlayer?.prepareToPlay()
        } catch {
            print("Error initializing sound player: \(error.localizedDescription)")
        }
    }
    
    @IBAction func createTransaction() {
        let transactionTypeIndex = ttSegControl.selectedSegmentIndex
        let transactionType = Transaction.TransactionType.allCases[transactionTypeIndex]
        
        // Unwrap the Text Fields safely
        var nameText = nameTextField.text
        if nameText == nil {
            nameText = "Unnamed Transaction"
        }
        
        var amtTransactedText = amtTransactedTextField.text
        if amtTransactedText == nil {
            amtTransactedText = "0.00"
        }
        
        let amtTransactedDec = Decimal(string: amtTransactedText!)!
        
        // Define date formatter params for printing purposes
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Convert UIImage to Data
        var imageData : Data
        
        if selectedImage != nil {
            imageData = (selectedImage?.jpegData(compressionQuality: 0.8))!
        } else {
            let defaultImage = UIImage(named: "Cash-Register")
            imageData = (defaultImage?.jpegData(compressionQuality: 0.8))!
        }
        
        // Create the Transaction object with the inputted values
        let transaction : Transaction = Transaction.init()
        transaction.initWithData(TransactionType: transactionType, TransactionName: nameText!, Recurring: recurringSlider.isOn ? true : false, Date: datePicker.date, AmountTransacted: amtTransactedDec, ImageData: imageData)
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let returnCode = mainDelegate.insertIntoDatabase(transaction: transaction)
        let returnMsg : String = returnCode == true ? "Transaction added" : "Transaction add failed"
        
        // Display an alert to the user, letting them know if their upload was successful or not
        let alertController = UIAlertController(title: "SQLite Add", message: returnMsg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Define code for the haptic event
        if supportsHaptics == true {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
            
            let pattern = try! CHHapticPattern(events: [event], parameters: [])
            let player = try! hapticEngine.makePlayer(with: pattern)
            
            do {
                try player.start(atTime: CHHapticTimeImmediate)
            } catch {
                print("Error playing haptic pattern: \(error.localizedDescription)")
            }
        } else {
            print("Haptics are not available on your device, could not play vibration")
        }
        
        // Push a banner notification
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "This is the body of the notification"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        // Play cha-ching
        playCashRegisterAudio()
        
        present(alertController, animated: true)
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning", message: "Sorry, we couldn't access your camera. Did you forget to enable permissions?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImage = pickedImage
            
            let recognizedText = readTextFromImage(image: self.selectedImage!)
            let totalText = determineTotalAlgo(ocrText: recognizedText!)
            
            // If the total can be detected by our OCR, autofill it in the text field to make things easier for the user
            if totalText != "0.0" {
                amtTransactedTextField.text = totalText
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func playCashRegisterAudio() {
        self.soundPlayer?.currentTime = 0
        self.soundPlayer?.numberOfLoops = 1
        self.soundPlayer?.play()
        print("Playing sound")
    }
}
