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
    let sectionTitleList = ["1週目", "2週目", "3週目", "4週目", "5週目"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSettings()
        
        realm = try! Realm()
        let predicate = NSPredicate("date", fromDate: getfirstDayOfMonth() as NSDate?, toDate: nil)
        itemList = realm.objects(Item.self).filter(predicate)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    func getfirstDayOfMonth() -> Date? {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month], from: Date())
        let firstDayOfMonth = calendar.date(from: comps)
        print("\(firstDayOfMonth)")
        return firstDayOfMonth
    }
    
    func getSumOfWeeks() -> [Int] {
        var sumOfWeeks:[Int] = []
        for (index, _) in sectionTitleList.enumerated() {
            let weekItemList = self.getWeekItemList(week: index+1)
            let sum: Int = weekItemList.sum(ofProperty: "cost")
            sumOfWeeks.append(sum)
        }
        return sumOfWeeks
    }

    func deleteItem(at index: Int) {
        try! realm.write {
            realm.delete(itemList[index])
        }
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func getWeekItemList(week: Int) -> Results<Item> {
        self.realm = try! Realm()
        let predicate = NSPredicate(format: "week == %d", week)
        let weekItemList = itemList.filter(predicate)
        return weekItemList
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TableHeader
        let sum = getSumOfWeeks()[section]
        header?.configure(title: sectionTitleList[section], sum: sum)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return getSumOfWeeks()[section] != 0 ? 50 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let week = section + 1
        let weekItemList = self.getWeekItemList(week: week)
        return weekItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let week = indexPath.section + 1
        let weekItemList = self.getWeekItemList(week: week)
        
        let sum: Int = weekItemList.sum(ofProperty: "cost")
        print(sum)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell {
            let item = weekItemList[indexPath.row]
            cell.nameLabel.text = item.title
            cell.costLabel.text = "\(item.cost)円"
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
