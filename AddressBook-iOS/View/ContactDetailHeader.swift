//
//  ContactDetailHeader.swift
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/8.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

import UIKit

class ContactDetailHeader: UIView {
    @IBOutlet weak var label: UILabel!
    func update(contactInfo: ContactInfo) {
        label.text = contactInfo.infoType
    }
}
