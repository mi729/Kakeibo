//
//  Models.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/06/13.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var title: String = ""
    @objc dynamic var cost: Int = 0
    @objc dynamic var date: Date = Date()
    @objc dynamic var week: Int = 1

    convenience init(partition: String, title: String) {
        self.init()
        self.title = title
    }
}

class Money: Object {
    @objc dynamic var income: Int = 0
    @objc dynamic var savings: Int = 0
    @objc dynamic var rent: Int = 0
    @objc dynamic var utility: Int = 0
    @objc dynamic var water: Int = 0
    @objc dynamic var internet: Int = 0
    @objc dynamic var insurance: Int = 0
    @objc dynamic var other1: Int = 0
    @objc dynamic var other2: Int = 0
}

