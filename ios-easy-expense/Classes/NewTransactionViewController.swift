//
//  NewTransactionViewController.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-05.
//

import UIKit

class NewTransactionViewController: UIViewController {
    
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
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        
        // Create the Transaction object with the inputted values
        let transaction : Transaction = Transaction.init()
        transaction.initWithData(TransactionType: transactionType, TransactionName: nameText!, Recurring: recurringSlider.isOn ? true : false, Date: datePicker.date, AmountTransacted: amtTransactedDec)
        
        // Printing the Transaction object mapped with all the inputs, will be removed after testing is complete
        print("Transaction Type: \(transaction.transactionType),\nTransaction Name: \(transaction.transactionName),\nRecurring: \(transaction.recurring),\nDate: \(dateFormatter.string(from: transaction.date!)),\nAmount Transacted: \(transaction.amountTransacted)")
    }

}
