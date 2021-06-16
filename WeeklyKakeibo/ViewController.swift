//
//  ViewController.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/08.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    private var realm: Realm!
    private var itemList: Results<Item>!
    private var token: NotificationToken!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        realm = try! Realm()
        itemList = realm.objects(Item.self)
        print(itemList ?? "itemlist is null")
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    func deleteItem(at index: Int) {
        try! realm.write {
            realm.delete(itemList[index])
        }
    }
    
    func reload() {
        tableView.reloadData()
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell {
            let object = itemList[indexPath.row]
            cell.nameLabel.text = object.title
            cell.costLabel.text = "\(object.cost)円"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(self.itemList[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            tableView.reloadData()
        }
    }
}
