//
//  ContactDetailViewCell.swift
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/8.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

import UIKit

class ContactDetailViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var field: UITextField!
    weak var delegate: ContactDetailEditableDelegate?
    weak var contactInfo: ContactInfo?
    var type: ContactDetailType?

    override func awakeFromNib() {
        super.awakeFromNib()
        field.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let d = delegate {
            return d.textFieldIsEditing
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let t = type {
            switch t {
            case .phone:
                contactInfo?.phone = textField.text
            case .email:
                contactInfo?.email = textField.text
            default:
                contactInfo?.address = textField.text
            }
        }
    }
    
    func update(type: ContactDetailType, contactInfo: ContactInfo, delegate: ContactDetailEditableDelegate?) {
        self.delegate = delegate
        self.contactInfo = contactInfo
        self.type = type
        var l: String
        let f: String
        switch type {
        case .address:
            l = "地址: "
            f = contactInfo.address ?? ""
        case .email:
            l = "邮箱: "
            f = contactInfo.email ?? ""
        case .phone:
            l = "电话: "
            f = contactInfo.phone ?? ""
        }
        label.text = l
        field.text = f
    }
    
}
