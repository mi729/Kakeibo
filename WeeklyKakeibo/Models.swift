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

