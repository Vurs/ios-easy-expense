//
//  NewTransactionViewController.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-05.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        // Create the Transaction object with the inputted values
        let transaction : Transaction = Transaction.init()
        transaction.initWithData(TransactionType: transactionType, TransactionName: nameText!, Recurring: recurringSlider.isOn ? true : false, Date: datePicker.date, AmountTransacted: amtTransactedDec, ImageData: imageData!) // TODO: Fix the bug here when no image is selected
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let returnCode = mainDelegate.insertIntoDatabase(transaction: transaction)
        let returnMsg : String = returnCode == true ? "Transaction added" : "Transaction add failed"
        
        // Display an alert to the user, letting them know if their upload was successful or not
        let alertController = UIAlertController(title: "SQLite Add", message: returnMsg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
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
            
            // TODO: Display a confirmation message telling the user that they successfully uploaded an image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
