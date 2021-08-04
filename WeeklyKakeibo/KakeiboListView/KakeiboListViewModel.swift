//
//  KakeiboListViewModel.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/07/25.
//  
//

import Foundation
import RealmSwift

class KakeiboListViewModel {
    private var realm: Realm!
    private var monthCounter = 0
    private var monthlyItemList: Results<Item>!
    var openedSections = Set<Int>()
    
    func updateList() {
        let displayDate = getDisplayDate()
        let firstDay: NSDate? = displayDate.startOfMonth as NSDate?
        let lastDay: NSDate? = displayDate.endOfMonth as NSDate?
        
        realm = try! Realm()
        let predicate = NSPredicate("date", fromDate: firstDay, toDate:  lastDay)
        let itemList = realm.objects(Item.self).filter(predicate)
        monthlyItemList = itemList
    }
    
    func getDisplayDate() -> Date {
        let currentDate = Date()
        let displayDate = Calendar.current.date(byAdding: .month, value: monthCounter, to: currentDate)!
        return displayDate
    }
    
    func getSumOfWeeks(sectionTitleList: [String]) -> [Int] {
        var sumOfWeeks:[Int] = []
        for (index, _) in sectionTitleList.enumerated() {
            let weekItemList = self.getWeekItemList(week: index + 1)
            let sum: Int = weekItemList.sum(ofProperty: "cost")
            sumOfWeeks.append(sum)
        }
        return sumOfWeeks
    }

    func getWeekItemList(week: Int) -> Results<Item> {
        let predicate = NSPredicate(format: "week == %d", week)
        let weekItemList = monthlyItemList.filter(predicate)
        return weekItemList
    }
    
    func editItem(item: Item, newTitle: String, newCost: Int) {
        if item.title == newTitle && item.cost == newCost {
            return
        }
        let realm = try! Realm()
        try! realm.write {
            item.title = newTitle
            item.cost = newCost
        }
    }

    func incrementMonth(constant: Int) {
        monthCounter += constant
    }

    func openCurrentSectionWeek(section: Int) {
        if monthCounter != 0 {
            openedSections.removeAll()
            return
        }
        openedSections.insert(section)
    }
    
    func setOpenedSections(section: Int) {
        if openedSections.contains(section) {
            openedSections.remove(section)
        } else {
            openedSections.insert(section)
        }
    }
}
