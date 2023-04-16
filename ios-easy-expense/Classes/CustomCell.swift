//
//  CustomCell.swift
//  ios-easy-expense
//
//  Created by Vincent Ursino on 2023-04-12.
//

import UIKit

class CustomCell: UITableViewCell {
    
    let headerLbl = UILabel()
    let transactionNameLbl = UILabel()
    let recurringLbl = UILabel()
    let dateLbl = UILabel()
    let attachedImgView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        headerLbl.textAlignment = .left
        headerLbl.font = UIFont.boldSystemFont(ofSize: 24)
        headerLbl.backgroundColor = .clear
        headerLbl.textColor = .black
        
        transactionNameLbl.textAlignment = .left
        transactionNameLbl.font = UIFont.boldSystemFont(ofSize: 18)
        transactionNameLbl.backgroundColor = .clear
        transactionNameLbl.textColor = .black
        
        recurringLbl.textAlignment = .left
        recurringLbl.font = UIFont.boldSystemFont(ofSize: 12)
        recurringLbl.backgroundColor = .clear
        recurringLbl.textColor = .black
        
        dateLbl.textAlignment = .left
        dateLbl.font = UIFont.boldSystemFont(ofSize: 18)
        dateLbl.backgroundColor = .clear
        dateLbl.textColor = .black
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(headerLbl)
        contentView.addSubview(transactionNameLbl)
        contentView.addSubview(recurringLbl)
        contentView.addSubview(dateLbl)
        contentView.addSubview(attachedImgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        headerLbl.frame = CGRect(x: 135, y: 5, width: 460, height: 30)
        transactionNameLbl.frame = CGRect(x: 135, y: 40, width: 460, height: 24)
        dateLbl.frame = CGRect(x: 135, y: 69, width: 460, height: 24)
        recurringLbl.frame = CGRect(x: 135, y: 99, width: 460, height: 24)
        attachedImgView.frame = CGRect(x: 20, y: 10, width: 80, height: 80)
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
