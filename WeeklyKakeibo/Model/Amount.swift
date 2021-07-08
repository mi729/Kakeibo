//
//  Money.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/07/06.
//  
//

import Foundation

struct Amount: Equatable {
    let name: String
    let value: Int
    var key: String = ""
}

extension Amount: Codable {}
