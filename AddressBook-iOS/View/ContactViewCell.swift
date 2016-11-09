//
//  ContactViewCell.swift
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/7.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var skypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(contact: Contact) {
        nameLabel.text = "\(contact.lastName ?? "") \(contact.firstName ?? "")"
        skypeLabel.text = contact.skype ?? ""
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
