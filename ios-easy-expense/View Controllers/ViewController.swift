//
//  ViewController.swift
//  EasyExpense
//
//  Created by Vincent Ursino on 2023-04-04.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Define Date params for the Transaction
        let dateString = "2023-01-01"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Set a default value if the conversion was not successful
        var date = dateFormatter.date(from: dateString)
        if date == nil {
            date = Date()
        }
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        
        // Test
        let transaction : Transaction = Transaction.init()
        transaction.initWithData(TransactionType: Transaction.TransactionType.Expense, TransactionName: "Demo Transaction", Recurring: true, Date: date!, AmountTransacted: 100.00)
        
        print("Transaction Type: \(transaction.transactionType),\nTransaction Name: \(transaction.transactionName),\nRecurring: \(transaction.recurring),\nDate: \(dateFormatter.string(from: date!)),\nAmount Transacted: \(transaction.amountTransacted)")
    }
}

