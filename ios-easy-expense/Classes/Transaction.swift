//
//  Transaction.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-04.
//

import UIKit

class Transaction: NSObject {
    enum TransactionType: String, CaseIterable {
        case Expense
        case Income
        case Transfer
    }
    
    var transactionType : TransactionType!
    var transactionName : String!
    var recurring : Bool!
    var date : Date!
    var amountTransacted : Decimal!
    
    
    func initWithData(TransactionType transactionType : TransactionType, TransactionName transactionName : String, Recurring recurring : Bool, Date date : Date, AmountTransacted amountTransacted : Decimal) {
        self.transactionType = transactionType
        self.transactionName = transactionName
        self.recurring = recurring
        self.date = date
        self.amountTransacted = amountTransacted
    }
}
