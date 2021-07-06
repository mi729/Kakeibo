//
//  GlobalVar.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/07/06.
//  
//

import Foundation

class GlobalVar {
    private init() {}
    static let shared = GlobalVar()
    var amounts = ["income","savings","rent","utility","water","internet","other1","other2"]
//    var income = "income"
//    var savings = "savings"
//    var rent = "rent"
//    var utility = "utility"
//    var water = "water"
//    var internet = "internet"
//    var other1 = "other1"
//    var other2 = "other2"
}
