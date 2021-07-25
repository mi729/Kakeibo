//
//  InputViewModel.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/07/18.
//  
//

import Foundation

class InputViewModel {
    func getWeekNumber(date: Date) -> Int {
        let calendar = Calendar.current
        let weekNumber = calendar.component(.weekOfMonth, from: date)

        guard let numberOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: date)?.count else {
            return 0
        }
        
        if numberOfWeeks <= 5 {
            return weekNumber
        }
        
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)!

        let numberOfDayOfFirstWeek = calendar.range(of: .day, in: .weekOfMonth, for: startOfMonth)?.count
        
        // Adjust week number when the number of weeks is 6.
        if numberOfDayOfFirstWeek == 1 {
            switch weekNumber {
            case 1:
                return weekNumber
            default:
                return weekNumber - 1
            }
        } else {
            switch weekNumber {
            case 6:
                return weekNumber - 1
            default:
                return weekNumber
            }
        }
    }
}
