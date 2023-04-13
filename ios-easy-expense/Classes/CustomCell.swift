//
//  CustomCell.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-12.
//

import UIKit

class CustomCell: UITableViewCell {
    
    let transactionTypeLbl = UILabel()
    let transactionNameLbl = UILabel()
    let recurringLbl = UILabel()
    let dateLbl = UILabel()
    let amountTransactedLbl = UILabel()
    let attachedImgView = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        transactionTypeLbl.textAlignment = .left
        transactionTypeLbl.font = UIFont.boldSystemFont(ofSize: 12)
        transactionTypeLbl.backgroundColor = .clear
        transactionTypeLbl.textColor = .black
        
        transactionNameLbl.textAlignment = .left
        transactionNameLbl.font = UIFont.boldSystemFont(ofSize: 12)
        transactionNameLbl.backgroundColor = .clear
        transactionNameLbl.textColor = .black
        
        recurringLbl.textAlignment = .left
        recurringLbl.font = UIFont.boldSystemFont(ofSize: 12)
        recurringLbl.backgroundColor = .clear
        recurringLbl.textColor = .black
        
        dateLbl.textAlignment = .left
        dateLbl.font = UIFont.boldSystemFont(ofSize: 12)
        dateLbl.backgroundColor = .clear
        dateLbl.textColor = .black
        
        amountTransactedLbl.textAlignment = .left
        amountTransactedLbl.font = UIFont.boldSystemFont(ofSize: 12)
        amountTransactedLbl.backgroundColor = .clear
        amountTransactedLbl.textColor = .black
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(transactionTypeLbl)
        contentView.addSubview(transactionNameLbl)
        contentView.addSubview(recurringLbl)
        contentView.addSubview(dateLbl)
        contentView.addSubview(amountTransactedLbl)
        contentView.addSubview(attachedImgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        transactionTypeLbl.frame = CGRect(x: 100, y: 5, width: 460, height: 20)
        transactionNameLbl.frame = CGRect(x: 100, y: 30, width: 460, height: 20)
        recurringLbl.frame = CGRect(x: 100, y: 55, width: 460, height: 20)
        dateLbl.frame = CGRect(x: 100, y: 80, width: 460, height: 20)
        amountTransactedLbl.frame = CGRect(x: 100, y: 105, width: 460, height: 20)
        attachedImgView.frame = CGRect(x: 5, y: 5, width: 65, height: 65)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
