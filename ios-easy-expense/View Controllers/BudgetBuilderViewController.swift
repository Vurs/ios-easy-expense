//
//  BudgetBuilderViewController.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-15.
//

import UIKit

class BudgetBuilderViewController: UIViewController {
    
    @IBOutlet var periodSegControl : UISegmentedControl!
    @IBOutlet var budgetTextField : UITextField!
    
    let defaults = UserDefaults.standard
    
    @IBAction func saveButtonPressed() {
        if let inputText = budgetTextField.text {
            if let budget = Double(inputText) {
                defaults.set(budget, forKey: "Budget")
                
                var budgetPeriod = "Monthly"
                
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
                let alertController = UIAlertController(title: "Error", message: "Please enter a valid number!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true)
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "An unexpected error occurred.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
