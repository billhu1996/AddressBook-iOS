//
//  ContactBasicViewCell.swift
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/8.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

import UIKit

class ContactBasicViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var skypeTextField: UITextField!
    weak var delegate: ContactDetailEditableDelegate?
    weak var contact: Contact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        twitterTextField.delegate = self
        skypeTextField.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if delegate != nil {
            return delegate!.textFieldIsEditing
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let c = contact {
            c.firstName = firstNameTextField.text
            c.lastName = lastNameTextField.text
            c.skype = skypeTextField.text
            c.twitter = twitterTextField.text
        }
    }
    
    func update(contact: Contact, delegate: ContactDetailEditableDelegate?) {
        self.contact = contact
        self.delegate = delegate
        firstNameTextField.text = contact.firstName
        lastNameTextField.text = contact.lastName
        twitterTextField.text = contact.twitter
        skypeTextField.text = contact.skype
        if contact.imageUrl != nil, let url = URL(string: contact.imageUrl) {
            avatarImageView.setImageWith(URLRequest(url: url),
                                         placeholderImage: nil,
                                         success: {
                                            [weak self] _, _, image in
                                            if let self_ = self {
                                                self_.avatarImageView.image = image
                                            }
            }, failure: nil)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
