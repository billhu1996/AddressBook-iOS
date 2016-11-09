//
//  GroupTableViewController.swift
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/7.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    var groups = [Group]()
    var cellNibName = "GroupViewCell"
    var page = 0
    
    override func loadView() {
        super.loadView()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: cellNibName, bundle: Bundle.main), forCellReuseIdentifier: cellNibName)
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addNewGroup))
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.mj_header.beginRefreshing()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    // MARK: - Table view datas
    
    func refresh() {
        page = 0
        Group.fetch(page, success: {
            [weak self] data in
            if let self_ = self {
                self_.page = 1
                self_.groups = data as! [Group]
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
    
    func loadMore() {
        tableView.mj_footer.beginRefreshing()
        Group.fetch(page, success: {
            [weak self] data in
            if let self_ = self {
                let newGroups = data as! [Group]
                if newGroups.count > 0 {
                    self_.groups.append(contentsOf: data as! [Group])
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellNibName, for: indexPath) as! GroupViewCell
        cell.update(group: groups[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let alertVC = UIAlertController(title: "确认删除", message: groups[indexPath.row].name, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "删除", style: .destructive, handler: { (_) in
                Group.delete(self.groups[indexPath.row].id, success: {
                    [weak self] _ in
                    if let self_ = self {
                        self_.groups.remove(at: indexPath.row)
                        self_.tableView.reloadData()
                        self_.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: max(indexPath.row - 1, 0)), at: UITableViewScrollPosition.middle, animated: true)
                    }
                    }, failure: nil)
            }))
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func addNewGroup() {
        let alertVC = UIAlertController(title: "创建新群组", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.placeholder = "群组名"
        }
        let textField = alertVC.textFields!.first!
        alertVC.addAction(UIAlertAction(title: "确定", style: .default) {
            (_) in
            Group.createNewGroup(textField.text,
                                 success: {
                                    [weak self] _ in
                                    if let self_ = self {
                                        self_.tableView.mj_header.beginRefreshing()
                                    }
                },
                                 failure: {
                                    message in
                                    print(message ?? "")
            })
        })
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactTableViewController") as! ContactTableViewController
        cvc.group = groups[indexPath.row]
        navigationController?.pushViewController(cvc, animated: true)
        tableView.cellForRow(at: indexPath)?.isSelected = false
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
