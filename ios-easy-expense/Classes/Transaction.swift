//
//  Transaction.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-04.
//

import UIKit

class Transaction: NSObject {
    enum TransactionType: Int, CaseIterable {
        case Expense
        case Income
        case Transfer
    }
    
    var transactionType : TransactionType!
    var transactionName : String!
    var recurring : Bool!
    var date : Date!
    var amountTransacted : Decimal!
    var attachedImg : Data!
    
    func initWithData(TransactionType transactionType : TransactionType, TransactionName transactionName : String, Recurring recurring : Bool, Date date : Date, AmountTransacted amountTransacted : Decimal, ImageData attachedImg : Data) {
        self.transactionType = transactionType
        self.transactionName = transactionName
        self.recurring = recurring
        self.date = date
        self.amountTransacted = amountTransacted
        self.attachedImg = attachedImg
    }
    
    func getTypeAsString() -> String {
        switch self.transactionType.rawValue {
        case 0:
            return "Expense"
        case 1:
            return "Income"
        case 2:
            return "Transfer"
        default:
            return "Undefined"
        }
    }
    
    func getDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = self.date!
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
