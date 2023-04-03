//
//  UserDefaultsService.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 02/04/2023.
//

import Foundation

struct UserDefaultsService {
    enum Key: String, CaseIterable {
        case favorites
    }

    private static var defaults: UserDefaults {
        .standard
    }

    public static func set(_ value: Any, key: Key) {
        defaults.setValue(value, forKey: key.rawValue)
    }

    public static func get<T>(_ value: T?, key: Key) -> T? {
        defaults.value(forKey: key.rawValue) as? T
    }

    public static func remove(key: Key) {
        defaults.removeObject(forKey: key.rawValue)
    }

    public static func array<T>(key: Key, type: T.Type) -> [T]? {
        return defaults.array(forKey: key.rawValue) as? [T]
    }
}
