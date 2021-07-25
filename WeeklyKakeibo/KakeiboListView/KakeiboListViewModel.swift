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
    func getDisplayDate(monthCounter: Int) -> Date {
        let currentDate = Date()
        let displayDate = Calendar.current.date(byAdding: .month, value: monthCounter, to: currentDate)!
        return displayDate
    }
    
    func getSumOfWeeks(sectionTitleList: [String], itemList: Results<Item>!) -> [Int] {
        var sumOfWeeks:[Int] = []
        for (index, _) in sectionTitleList.enumerated() {
            let weekItemList = self.getWeekItemList(week: index + 1, itemList: itemList)
            let sum: Int = weekItemList.sum(ofProperty: "cost")
            sumOfWeeks.append(sum)
        }
        return sumOfWeeks
    }

    func getWeekItemList(week: Int, itemList: Results<Item>!) -> Results<Item> {
        let predicate = NSPredicate(format: "week == %d", week)
        let weekItemList = itemList.filter(predicate)
        return weekItemList
    }
}
