//
//  Bundle.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation

public extension Bundle {
    
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    static var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String
    }
    
//    static func thisApp: Bundle {
//        return Bundle(for: AppDelegate.self)
//    }
    
    static var version: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
