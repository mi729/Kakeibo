//
//  ViewController+TableViewDelegate.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/20.
//

import UIKit
import RealmSwift

extension KakeiboListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleList.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TableHeader
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDidTap(_:)))
        header?.addGestureRecognizer(gesture)
        header?.tag = section
        
        let sum = getSumOfWeeks()[section]
        header?.configure(title: sectionTitleList[section], sum: sum)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return getSumOfWeeks()[section] != 0 ? 44 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedSections.contains(section) {
            let week = section + 1
            let weekItemList = self.getWeekItemList(week: week)
            return weekItemList.count
        } else {
            return 0
        }
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
            return 38
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
    
    @objc func sectionHeaderDidTap(_ sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            if openedSections.contains(section) {
                openedSections.remove(section)
            } else {
                openedSections.insert(section)
            }

            tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }
}
