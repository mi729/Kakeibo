//
//  ViewController+TableViewDelegate.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/20.
//

import UIKit
import RealmSwift

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

        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell {
            let item = weekItemList[indexPath.row]
            cell.nameLabel.text = item.title
            cell.costLabel.text = "\(item.cost) 円"
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let week = indexPath.section + 1
        let weekItemList = self.getWeekItemList(week: week)
        let targetItem = weekItemList[indexPath.row]
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(targetItem)
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            tableView.reloadData()
        }
    }
}
