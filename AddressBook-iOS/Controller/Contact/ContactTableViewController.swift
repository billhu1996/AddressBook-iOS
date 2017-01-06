//
//  ContactTableViewController.swift
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/7.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    var group: Group?
    var contacts = [Contact]()
    var cellNibName = "ContactViewCell"
    var page = 0
    weak var selectContactdelegate: ContactTableViewController?
    var selectedContact: Contact?
    
    override func loadView() {
        super.loadView()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: cellNibName, bundle: Bundle.main), forCellReuseIdentifier: cellNibName)
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        if selectContactdelegate == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addNewContact))
        }
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.mj_header.beginRefreshing()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if group != nil && selectedContact != nil {
            GroupRelationship.addContact(with: group!.id, contactID: selectedContact!.id,
                                         success: {
                                            [weak self] _ in
                                            if let self_ = self {
                                                self_.tableView.mj_header.beginRefreshing()
                                            }
            },
                                         failure: {
                                            fm in
                                            print(fm ?? "")
            })
            selectedContact = nil
        }
    }
    
    // MARK: - Table view datas
    
    func refresh() {
        page = 0
        if let id = group?.id, selectContactdelegate == nil {
            GroupRelationship.fetchContact(with: id,
                                           page: page,
                                           success: {
                                            [weak self] data in
                                            if let self_ = self {
                                                self_.page = 1
                                                self_.contacts = data as! [Contact]
                                                self_.tableView.mj_header.endRefreshing()
                                                self_.tableView.reloadData()
                                            }
                },
                                           failure: {
                                            [weak self] message in
                                            if let self_ = self {
                                                self_.tableView.mj_header.endRefreshing()
                                                print(message ?? "")
                                            }
            })
        } else {
            Contact.fetch(page, success: {
                [weak self] data in
                if let self_ = self {
                    self_.page = 1
                    self_.contacts = data as! [Contact]
                    self_.tableView.mj_header.endRefreshing()
                    self_.tableView.reloadData()
                }
                }, failure: {
                    [weak self] message in
                    if let self_ = self {
                        self_.tableView.mj_header.endRefreshing()
                        print(message ?? "")
                    }
            })
        }
    }
    
    func loadMore() {
        if let id = group?.id, selectContactdelegate == nil {
            GroupRelationship.fetchContact(with: id,
                                           page: page,
                                           success: {
                                            [weak self] data in
                                            if let self_ = self {
                                                let newContacts = data as! [Contact]
                                                if newContacts.count > 0 {
                                                    self_.contacts.append(contentsOf: data as! [Contact])
                                                    self_.page += 1
                                                    self_.tableView.reloadData()
                                                }
                                                self_.tableView.mj_footer.endRefreshing()
                                            }
                },
                                           failure: {
                                            [weak self] message in
                                            if let self_ = self {
                                                self_.tableView.mj_footer.endRefreshing()
                                                print(message ?? "")
                                            }
            })
        } else {
            tableView.mj_footer.beginRefreshing()
            Contact.fetch(page, success: {
                [weak self] data in
                if let self_ = self {
                    let newContacts = data as! [Contact]
                    if newContacts.count > 0 {
                        self_.contacts.append(contentsOf: data as! [Contact])
                        self_.page += 1
                        self_.tableView.reloadData()
                    }
                    self_.tableView.mj_footer.endRefreshing()
                }
                }, failure: {
                    [weak self] message in
                    if let self_ = self {
                        self_.tableView.mj_footer.endRefreshing()
                        print(message ?? "")
                    }
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellNibName, for: indexPath) as! ContactViewCell
        cell.update(contact: contacts[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let group = group {
                let alertVC = UIAlertController(title: "确认从\(group.name ?? "")中删除", message: "\(contacts[indexPath.row].firstName!) \(contacts[indexPath.row].lastName!)", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { (_) in
                    GroupRelationship.deleteContect(with: group.id,
                                                    contactID: self.contacts[indexPath.row].id,
                                                    success: {
                                                        [weak self] _ in
                                                        if let self_ = self {
                                                            self_.contacts.remove(at: indexPath.row)
                                                            self_.tableView.reloadData()
                                                            let indexPath = IndexPath(row: max(indexPath.row - 1, 0), section: indexPath.section)
                                                            if self_.tableView.cellForRow(at: indexPath) != nil {
                                                                self_.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
                                                            }
                                                        }
                        },
                                                    failure: nil)
                }))
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                present(alertVC, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "确认删除", message: "\(contacts[indexPath.row].firstName!) \(contacts[indexPath.row].lastName!)", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { (_) in
                    Contact.delete(self.contacts[indexPath.row].id, success: {
                        [weak self] _ in
                        if let self_ = self {
                            self_.contacts.remove(at: indexPath.row)
                            self_.tableView.reloadData()
                            let indexPath = IndexPath(row: max(indexPath.row - 1, 0), section: indexPath.section)
                            if self_.tableView.cellForRow(at: indexPath) != nil {
                                self_.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
                            }
                        }
                        }, failure: nil)
                }))
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                present(alertVC, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectContactdelegate != nil {
            selectContactdelegate?.selectedContact = contacts[indexPath.row]
            navigationController!.popViewController(animated: true)
        } else {
            let dvc = ContactDetailViewController(contact: contacts[indexPath.row])
            navigationController?.pushViewController(dvc, animated: true)
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func addContactToGroup() {
        if selectedContact != nil && group != nil {
            GroupRelationship.addContact(with: group!.id, contactID: selectedContact!.id,
                                         success: {
                                            [weak self] _ in
                                            if let self_ = self {
                                                self_.tableView.mj_header.beginRefreshing()
                                            }
            },
                                         failure: {
                                            fm in
                                            print(fm ?? "")
            })
        }
    }
    
    func addNewContact() {
        if group != nil && selectContactdelegate == nil {
            let cvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactTableViewController") as! ContactTableViewController
            cvc.group = group
            cvc.selectContactdelegate = self
            navigationController?.pushViewController(cvc, animated: true)
            print("")
        } else if group == nil {
            let dvc = ContactDetailViewController()
            navigationController?.pushViewController(dvc, animated: true)
        }
    }
    
    
    
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
