//
//  Dictionary.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation
import UIKit


public extension Dictionary where Key == UIImagePickerController.InfoKey, Value == Any {
    
    var stringAnyDictionary: [String: Any] {
        return [String: Any](uniqueKeysWithValues: map {key, value in (key.rawValue, value)})
    }
}


public extension Dictionary  {
    
    var hasElements: Bool {
        for (_, _) in self {
            return true
        }
        return false
    }
}


public extension Dictionary where Value == Int {
    
    mutating func replace(oldValue: Int, newValue: Int) {
        var keys: [Key] = []
        for (key, value) in self where value == oldValue {
            keys.append(key)
        }
        for key in keys {
            self[key] = newValue
        }
    }
    
    mutating func removePairsWith(oldValue: Int) {
        var keys: [Key] = []
        for (key, value) in self where value == oldValue {
            keys.append(key)
        }
        for key in keys {
            self[key] = nil
        }
    }
}



public extension Dictionary where Key ==  String, Value == Double {
    
    var json: [String: String] {
        return mapValues { String($0) }
    }
}


public extension Dictionary where Key == String, Value == Any {
    var success: Bool {
        guard let success = self["success"] as? Int else { return false }
        return success.boolValue
    }
    
    var emailIsAvailable: Bool {
        return true
    }
    
    var userIsBlocked: Bool {
        return true
    }
    
    
    func value<T>(for key: String) -> T? {
        if let value = self[key] as? T {
            return value
        } else {
            print("Warning: parsing failed for key: \(key)")
            return nil
        }
    }
}
