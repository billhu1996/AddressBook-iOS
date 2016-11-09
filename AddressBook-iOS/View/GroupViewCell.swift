//
//  GroupViewCell.swift
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/7.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

import UIKit

class GroupViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(group: Group) {
        nameLabel.text = group.name!
    }
    
}
