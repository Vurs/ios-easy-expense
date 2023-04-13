//
//  ViewTransactionsViewController.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-08.
//

import UIKit

class ViewTransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCell ?? CustomCell(style: .default, reuseIdentifier: "cell")
        
        let rowNum = indexPath.row
        tableCell.transactionTypeLbl.text = mainDelegate.transactions[rowNum].getTypeAsString()
        tableCell.transactionNameLbl.text = mainDelegate.transactions[rowNum].transactionName
        tableCell.recurringLbl.text = mainDelegate.transactions[rowNum].recurring ? "Recurring" : ""
        tableCell.dateLbl.text = mainDelegate.transactions[rowNum].getDateAsString()
        tableCell.amountTransactedLbl.text = mainDelegate.transactions[rowNum].amountTransacted.description
        
        // If there is image data, convert it to a UIImage and display it
        if let imageData = mainDelegate.transactions[rowNum].attachedImg {
            let image = UIImage(data: imageData)
            tableCell.attachedImgView.image = image
        }
        
        // TODO: Add a default image for when image data is not available
        
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
    }

}
