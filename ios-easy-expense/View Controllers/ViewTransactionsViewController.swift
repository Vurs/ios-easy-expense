//
//  ViewTransactionsViewController.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-08.
//

import UIKit

class ViewTransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var leftToSpend : UILabel!
    
    let defaults = UserDefaults.standard
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
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
    
    // TODO: Either use this or right/left sliding to allow user to see more info about each transaction & view the receipt in full view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowNum = indexPath.row
        
        let alertController = UIAlertController(title: "Test", message: "Test", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainDelegate.readDataFromDatabase()
        
        var amountToDeduct = 0.0
        for transaction in mainDelegate.transactions {
            if transaction.transactionType == Transaction.TransactionType.Expense || transaction.transactionType == Transaction.TransactionType.Transfer {
                amountToDeduct += Double(truncating: transaction.amountTransacted as NSNumber)
            } else if transaction.transactionType == Transaction.TransactionType.Income {
                amountToDeduct -= Double(truncating: transaction.amountTransacted as NSNumber)
            }
        }
        
        var budget = 0.0
        
        if let tempBudget = defaults.object(forKey: "Budget") as? Double {
            budget = tempBudget
        }
        
        let remainingBudget = budget - amountToDeduct
        
        var returnString = String(remainingBudget)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let myNumber = formatter.number(from: returnString) {
            returnString = formatter.string(from: myNumber)!
        }
        
        leftToSpend.text = "$\(returnString)"
    }
}
