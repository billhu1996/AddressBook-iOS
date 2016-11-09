//
//  ContactDetailViewController.swift
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/8.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

import UIKit

protocol ContactDetailEditableDelegate: UITextFieldDelegate {
    var textFieldIsEditing: Bool { get set }
}

enum ContactDetailType {
    case phone
    case email
    case address
}

class ContactDetailViewController: UITableViewController, ContactDetailEditableDelegate {
    
    var contact: Contact
    var contactDetails = [ContactInfo]()
    var textFieldIsEditing = false
    lazy var basicCell: ContactBasicViewCell = {
        let cell = Bundle.main.loadNibNamed("ContactBasicViewCell", owner: nil, options: nil)?.first as! ContactBasicViewCell
        cell.selectionStyle = .none
        return cell
    }()
    var cellNibName = "ContactDetailViewCell"
    var freshCount = 0

    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.contact = Contact()
        for _ in 0..<3 {
            contactDetails.append(ContactInfo())
        }
        contactDetails[0].infoType = "home"
        contactDetails[1].infoType = "mobile"
        contactDetails[2].infoType = "work"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: cellNibName, bundle: Bundle.main), forCellReuseIdentifier: cellNibName)
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.plain, target: self, action: #selector(changeTextFieldEditStyle))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contactDetails.count == 0 {
            tableView.mj_header.beginRefreshing()
        } else {
            changeTextFieldEditStyle()
        }
    }
    
    // MARK: - Table view datas
    
    func refresh() {
        Contact.fetchsingleContact(withID: contact.id,
                                   success: {
                                    [weak self] data in
                                    if let self_ = self {
                                        self_.contact = data as! Contact
                                        self_.tableView.reloadData()
                                        self_.tableView.mj_header.endRefreshing()
                                    }
        },
                                   failure: {
                                    [weak self] failureMessage in
                                    if let self_ = self {
                                        self_.tableView.mj_header.endRefreshing()
                                    }
                                    print(failureMessage ?? "")
        })
        ContactInfo.fetch(withID: contact.id,
                          success: {
                            [weak self] data in
                            if let self_ = self {
                                if let infos = data as? [ContactInfo] {
                                    self_.contactDetails = infos
                                    self_.tableView.reloadData()
                                }
                                self_.tableView.mj_header.endRefreshing()
                            }
        },
                          failure: {
                            [weak self] failureMessage in
                            if let self_ = self {
                                self_.tableView.mj_header.endRefreshing()
                            }
                            print(failureMessage ?? "")
        })
    }
    
    func changeTextFieldEditStyle() {
        if textFieldIsEditing {
            textFieldIsEditing = false
            if contact.id != 0 {
                Contact.edit(contact.id, firstName: basicCell.firstNameTextField.text, lastName: basicCell.lastNameTextField.text, imageUrl: contact.imageUrl, twitter: basicCell.twitterTextField.text, skype: basicCell.skypeTextField.text, notes: contact.notes,
                             success: {
                                [weak self] _ in
                                if let self_ = self {
                                    self_.freshCount += 1
                                    if self_.freshCount > self_.contactDetails.count {
                                        self_.freshCount = 0
                                        self_.navigationItem.rightBarButtonItem?.title = "编辑"
                                        self_.tableView.mj_header.beginRefreshing()
                                    }
                                }
                    }, failure: {
                        [weak self] failureMessage in
                        print(failureMessage ?? "")
                        if let self_ = self {
                            self_.freshCount += 1
                            if self_.freshCount > self_.contactDetails.count {
                                self_.freshCount = 0
                                self_.navigationItem.rightBarButtonItem?.title = "编辑"
                                self_.tableView.mj_header.beginRefreshing()
                            }
                        }
                })
                for i in 0..<contactDetails.count {
                    let detail = contactDetails[i]
                    let phone = (tableView.cellForRow(at: IndexPath(row: 0, section: i + 1)) as! ContactDetailViewCell).field.text
                    let email = (tableView.cellForRow(at: IndexPath(row: 1, section: i + 1)) as! ContactDetailViewCell).field.text
                    let address = (tableView.cellForRow(at: IndexPath(row: 2, section: i + 1)) as! ContactDetailViewCell).field.text
                    ContactInfo.edit(detail.id, infoType: detail.infoType, phone: phone, email: email, address: address, city: detail.city, state: detail.state, zip: detail.zip, country: detail.country,
                                     success: {
                                        [weak self] _ in
                                        if let self_ = self {
                                            self_.freshCount += 1
                                            if self_.freshCount > self_.contactDetails.count {
                                                self_.freshCount = 0
                                                self_.navigationItem.rightBarButtonItem?.title = "编辑"
                                                self_.tableView.mj_header.beginRefreshing()
                                            }
                                        }
                        }, failure: {
                            [weak self] failureMessage in
                            print(failureMessage ?? "")
                            if let self_ = self {
                                self_.freshCount += 1
                                if self_.freshCount > self_.contactDetails.count {
                                    self_.freshCount = 0
                                    self_.navigationItem.rightBarButtonItem?.title = "编辑"
                                    self_.tableView.mj_header.beginRefreshing()
                                }
                            }
                    })
                }
            } else {
                Contact.createNewContact(basicCell.firstNameTextField.text, lastName: basicCell.lastNameTextField.text, imageUrl: contact.imageUrl, twitter: basicCell.twitterTextField.text, skype: basicCell.skypeTextField.text, notes: contact.notes,
                                         success: {
                                            [weak self] id in
                                            if let ID = id as? Int, let self_ = self {
                                                for i in 0..<self_.contactDetails.count {
                                                    let detail = self_.contactDetails[i]
                                                    let phone = (self_.tableView.cellForRow(at: IndexPath(row: 0, section: i + 1)) as! ContactDetailViewCell).field.text
                                                    let email = (self_.tableView.cellForRow(at: IndexPath(row: 1, section: i + 1)) as! ContactDetailViewCell).field.text
                                                    let address = (self_.tableView.cellForRow(at: IndexPath(row: 2, section: i + 1)) as! ContactDetailViewCell).field.text
                                                    let infoType = self_.contactDetails[i].infoType
                                                    ContactInfo.createNewContactInfo(ID, infoType: infoType, phone: phone, email: email, address: address, city: detail.city, state: detail.state, zip: detail.zip, country: detail.country,
                                                                     success: {
                                                                        [weak self] _ in
                                                                        if let self_ = self {
                                                                            self_.freshCount += 1
                                                                            if self_.freshCount >= self_.contactDetails.count {
                                                                                self_.freshCount = 0
                                                                                self_.navigationItem.rightBarButtonItem?.title = "编辑"
                                                                                self_.tableView.mj_header.beginRefreshing()
                                                                            }
                                                                        }
                                                        },
                                                                     failure: {
                                                                        [weak self] failureMessage in
                                                                        print(failureMessage ?? "")
                                                                        if let self_ = self {
                                                                            self_.freshCount += 1
                                                                            if self_.freshCount >= self_.contactDetails.count {
                                                                                self_.freshCount = 0
                                                                                self_.navigationItem.rightBarButtonItem?.title = "编辑"
                                                                                self_.tableView.mj_header.beginRefreshing()
                                                                            }
                                                                        }
                                                    })
                                                }
                                            }
                },
                                         failure: {
                                            failureMessage in
                                            print(failureMessage ?? "")
                })
            }
        } else {
            textFieldIsEditing = true
            navigationItem.rightBarButtonItem?.title = "完成"
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactDetails.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            basicCell.update(contact: contact, delegate: self)
            return basicCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellNibName, for: indexPath) as! ContactDetailViewCell
            switch indexPath.row {
            case 0:
                cell.update(type: .phone, contactInfo: contactDetails[indexPath.section - 1], delegate: self)
            case 1:
                cell.update(type: .email, contactInfo: contactDetails[indexPath.section - 1], delegate: self)
            case 2:
                cell.update(type: .address, contactInfo: contactDetails[indexPath.section - 1], delegate: self)
            default:
                break
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        default:
            let view = Bundle.main.loadNibNamed("ContactDetailHeader", owner: self, options: nil)?.first as! ContactDetailHeader
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
            view.update(contactInfo: contactDetails[section - 1])
            return view
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
