//
//  ItemViewController.swift
//  ChatTestRealm
//
//  Created by Kai Qiao on 11/14/19.
//  Copyright © 2019 iKai0314. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm: Realm
    let items: Results<Item>
    
    var notificationToken: NotificationToken?
    @IBOutlet weak var itemTableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(Item.self).sorted(byKeyPath: "timestamp", ascending: false)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Things ToDo!"
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        
        notificationToken = items.observe { [weak self] (changes) in
            guard let tableView = self?.itemTableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    @objc @IBAction func addItemBarPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            let item = Item()
            item.body = textField.text ?? ""
            try! self.realm.write {
                self.realm.add(item)
            }
            // do something with textField
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "New Item Text"
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") ?? UITableViewCell(style: .default, reuseIdentifier: "ItemCell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.body
        cell.accessoryType = item.isDone ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        try! realm.write {
            item.isDone = !item.isDone
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = items[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
    
    


}

