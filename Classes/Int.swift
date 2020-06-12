//
//  Int.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation

fileprivate let locationFrequency = "locationFrequency"

public extension Int {
    var boolValue: Bool { return self != 0 }
    
    @discardableResult
    mutating func increment() -> Int {
        self = self + 1
        return self
    }
    
    var string: String {
        return String(self)
    }
    
    var yearsInSeconds: Double {
        return Double(self) * 365 * 24 * 60 * 60
    }
    
    static var frequencyOfLocationUpdatesInMinutes: Int {
        get {
            return Int(Keychain.loadFrom(key: locationFrequency) ?? "5") ?? 5
        }
        set(new) {
            Keychain.save(key: locationFrequency, value: String(new))
        }
    }
    
    var indexPaths: [IndexPath] {
        return indexPaths()
    }
    
    ///Returns a corresponding indexpath totalling equal to the integer.
    func indexPaths(inSection: Int = 1) -> [IndexPath] {
        var indxPaths: [IndexPath] = []
        for row in 0..<self {
            indxPaths.append(IndexPath(row: row, section: inSection))
        }
        return indxPaths
    }
    
    init?(_ optionalString: String?) {
        guard let string = optionalString, let int = Int(string) else { return nil }
        self = int
    }
}
