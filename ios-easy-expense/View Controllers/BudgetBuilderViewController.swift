//
//  BudgetBuilderViewController.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-15.
//  This class handles the creation of a budget and a budget period. The inputted values are sent to UserDefaults where it is
//  pulled from other classes when needed.
//

import UIKit

class BudgetBuilderViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var periodSegControl : UISegmentedControl!
    @IBOutlet var budgetTextField : UITextField!
    
    let defaults = UserDefaults.standard
    
    /// This method is used to remove the keyboard when enter is pressed.
    /// - Parameters:
    ///     - textField: The UITextField
    /// - Returns: textField.resignFirstResponder()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    /// This method is called when the Save button is pressed. It validates the input, and if the input is valid, saves the input to UserDefaults.
    @IBAction func saveButtonPressed() {
        if let inputText = budgetTextField.text {
            // If the input is indeed a double
            if let budget = Double(inputText) {
                defaults.set(budget, forKey: "Budget")
                
                // Set a default budget period
                var budgetPeriod = "Monthly"
                
                // Check which segment was selected
                switch periodSegControl.selectedSegmentIndex {
                case 0:
                    budgetPeriod = "Monthly"
                    break
                case 1:
                    budgetPeriod = "Bi-Weekly"
                    break
                default:
                    budgetPeriod = "Weekly"
                    break
                }
                
                defaults.set(budgetPeriod, forKey: "BudgetPeriod")
                defaults.synchronize()
                
                let alertController = UIAlertController(title: "Success", message: "Your budget info has been saved.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true)
            } else {
                // The input was deemed invalid
                let alertController = UIAlertController(title: "Error", message: "Please enter a valid number!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true)
            }
        } else {
            // Unexpected error
            let alertController = UIAlertController(title: "Error", message: "An unexpected error occurred.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        budgetTextField.delegate = self
    }
}
