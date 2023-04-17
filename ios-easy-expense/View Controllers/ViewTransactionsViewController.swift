//
//  ViewTransactionsViewController.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-08.
//  This class handles pulling data from the database and displaying it elegantly in our TableView.
//

import UIKit

class ViewTransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var leftToSpend : UILabel!
    
    let defaults = UserDefaults.standard
    
    /// This method is used to define how many rows in the section there will be.
    /// - Parameters:
    ///     - tableView: The UITableView
    ///     - section: The section
    /// - Returns: The number of transaction objects in the mainDelegate.transactions array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.transactions.count
    }
    
    /// This method is used for defining the height of each row in the table.
    /// - Parameters:
    ///     - tableView: The UITableView
    ///     - indexPath: The IndexPath
    /// - Returns: The height for each row in the table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    /// This method is automatically called when a new cell is generated.
    /// - Parameters:
    ///     - tableView: The UITableView
    ///     - indexPath: The IndexPath
    /// - Returns: The table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCell ?? CustomCell(style: .default, reuseIdentifier: "cell")
        
        let rowNum = indexPath.row
        
        let amountTransacted = mainDelegate.transactions[rowNum].amountTransacted
        let amountStr = amountTransacted!.description
        var amountDbl = 0.0
        
        if let temp = Double(amountStr) {
            amountDbl = temp
        }
        
        let formattedAmountStr = String(format: "%.2f", amountDbl)
        
        // Fill out the text labels with their corresponding data
        tableCell.headerLbl.text = mainDelegate.transactions[rowNum].getTypeAsString() + " - $" + formattedAmountStr
        tableCell.transactionNameLbl.text = mainDelegate.transactions[rowNum].transactionName
        tableCell.dateLbl.text = mainDelegate.transactions[rowNum].getDateAsReadableString()
        
        if mainDelegate.transactions[rowNum].recurring == true {
            tableCell.dateLbl.text! += " - Recurring"
        }
        
        // If there is image data, convert it to a UIImage and display it
        if let imageData = mainDelegate.transactions[rowNum].attachedImg {
            let image = UIImage(data: imageData)
            tableCell.attachedImgView.image = image
        }
        
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainDelegate.readDataFromDatabase()
        
        // Update the "Money Left to Spend" label so the user knows how much is left in their budget for the period
        var amountToDeduct = 0.0
        for transaction in mainDelegate.transactions {
            // If the transaction is of type Expense or Transfer, add it to the amount to deduct
            if transaction.transactionType == Transaction.TransactionType.Expense || transaction.transactionType == Transaction.TransactionType.Transfer {
                amountToDeduct += Double(truncating: transaction.amountTransacted as NSNumber)
            } else if transaction.transactionType == Transaction.TransactionType.Income {
                // Else, remove it from the amount to deduct
                amountToDeduct -= Double(truncating: transaction.amountTransacted as NSNumber)
            }
        }
        
        var budget = 0.0
        
        // Fetch the Budget info from UserDefaults
        if let tempBudget = defaults.object(forKey: "Budget") as? Double {
            budget = tempBudget
        }
        
        let remainingBudget = budget - amountToDeduct
        
        // Format the string and send it to the leftToSpend label
        var returnString = String(remainingBudget)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let myNumber = formatter.number(from: returnString) {
            returnString = formatter.string(from: myNumber)!
        }
        
        leftToSpend.text = "$\(returnString)"
    }
}
