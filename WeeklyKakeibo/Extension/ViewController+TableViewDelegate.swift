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
        
        let weeklyMoney = UserDefaults.standard.integer(forKey: "weeklyMoney")
        let remaining = weeklyMoney - kakeiboListViewModel.getSumOfWeeks(sectionTitleList: sectionTitleList)[section]
        header?.configure(title: sectionTitleList[section], remaining: remaining)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer") as? TableFooterView
        let sum = kakeiboListViewModel.getSumOfWeeks(sectionTitleList: sectionTitleList)[section]
        footer?.configure(sum: sum)
        return footer
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sum = kakeiboListViewModel.getSumOfWeeks(sectionTitleList: sectionTitleList)[section]
        return sum != 0 ? 44 : 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sum = kakeiboListViewModel.getSumOfWeeks(sectionTitleList: sectionTitleList)[section]
        return sum != 0 ? 44 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let week = section + 1
        let weekItemList = kakeiboListViewModel.getWeekItemList(week: week)
        
        if kakeiboListViewModel.openedSections.contains(section) && !weekItemList.isEmpty {
             return weekItemList.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nameText: String
        let costText: String
        let font: UIFont
        
        let week = indexPath.section + 1
        let weekItemList = kakeiboListViewModel.getWeekItemList(week: week)
        let item = weekItemList[indexPath.row]
        nameText = item.title
        costText = "\(item.cost) 円"
        font = .systemFont(ofSize: 16, weight: .regular)

        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell {
            cell.nameLabel.text = nameText
            cell.nameLabel.font = font
            cell.costLabel.text = costText
            cell.costLabel.font = font
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 38
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let week = indexPath.section + 1
        let weekItemList = kakeiboListViewModel.getWeekItemList(week: week)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let week = indexPath.section + 1
        let weekItemList = kakeiboListViewModel.getWeekItemList(week: week)
        let targetItem = weekItemList[indexPath.row]
        
        
        self.showEditView(item: targetItem)
    }
    
    func isLastItemOfSection(week: Int) -> Bool {
        return kakeiboListViewModel.getWeekItemList(week: week).count == 1
    }
    
    @objc func sectionHeaderDidTap(_ sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            kakeiboListViewModel.setOpenedSections(section: section)
            tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }
}
