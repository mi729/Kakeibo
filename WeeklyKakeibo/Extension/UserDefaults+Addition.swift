//
//  UserDefaults+Addition.swift
//  WeeklyKakeibo
//
//  Created by mi729 on 2021/07/08.
//  
//

import Foundation

protocol KeyNamespaceable {
        func namespaced<T: RawRepresentable>(_ key: T) -> String
}

extension KeyNamespaceable {

        func namespaced<T: RawRepresentable>(_ key: T) -> String {
                return "\(Self.self).\(key.rawValue)"
        }
}

protocol StringDefaultSettable : KeyNamespaceable {
        associatedtype StringKey : RawRepresentable
}

extension StringDefaultSettable where StringKey.RawValue == String {

        func set(_ value: String, forKey key: StringKey) {
                let key = namespaced(key)
                UserDefaults.standard.set(value, forKey: key)
        }

        @discardableResult
        func string(forKey key: StringKey) -> String? {
                let key = namespaced(key)
                return UserDefaults.standard.string(forKey: key)
        }
}

extension UserDefaults : StringDefaultSettable {
        enum StringKey : String {
                case tel
        }
}
