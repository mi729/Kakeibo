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
    private var token: NotificationToken!
    var itemList: Results<Item>!
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

    func getWeekItemList(week: Int) -> Results<Item> {
        self.realm = try! Realm()
        let predicate = NSPredicate(format: "week == %d", week)
        let weekItemList = itemList.filter(predicate)
        return weekItemList
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
