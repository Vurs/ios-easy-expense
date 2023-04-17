//
//  Transaction.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-04.
//  This class handles the fields and methods of the Transaction class.
//

import UIKit

class Transaction: NSObject {
    // An enum describing the type of transaction
    enum TransactionType: Int, CaseIterable {
        case Expense
        case Income
        case Transfer
    }
    
    // The transaction type
    var transactionType : TransactionType!
    
    // The transaction name
    var transactionName : String!
    
    // Whether the transaction is recurring or not
    var recurring : Bool!
    
    // The date of the transaction
    var date : Date!
    
    // The amount of money that was transacted
    var amountTransacted : Decimal!
    
    // The attached receipt image, if any
    var attachedImg : Data!
    
    /// This method is a constructor for creating Transaction objects with parameters.
    /// - Parameters:
    ///     - transactionType: The transaction type
    ///     - transactionName: The transaction name
    ///     - recurring: The recurring value
    ///     - date: The date of the transaction
    ///     - amountTransacted: The amount transacted
    ///     - attachedImg: The attached receipt image
    /// - Returns: A string containing all text found in the image, separated by '\n'.
    func initWithData(TransactionType transactionType : TransactionType, TransactionName transactionName : String, Recurring recurring : Bool, Date date : Date, AmountTransacted amountTransacted : Decimal, ImageData attachedImg : Data) {
        self.transactionType = transactionType
        self.transactionName = transactionName
        self.recurring = recurring
        self.date = date
        self.amountTransacted = amountTransacted
        self.attachedImg = attachedImg
    }
    
    /// This method is a helper method used for returning the transaction type as a string.
    /// - Returns: The string value of the transaction type.
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
    
    /// This method is a helper method used for returning the date as a string.
    /// - Returns: The string value of the date.
    func getDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = self.date!
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    /// This method is a helper method used for returning the date as a human-readable string.
    /// - Returns: The human-readable string value of the date.
    func getDateAsReadableString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let date = self.date!
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
