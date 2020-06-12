//
//  Environment.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/1/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation

// modular
public enum Environment {
    case debug, adhoc, production
    
    static var current: Environment {
        #if DEBUG
        return .debug
        #elseif ADHOC
        return .adhoc
        #else
        return .production
        #endif
    }
}


// modular
public enum AppConfiguration {
    case Debug
    case TestFlight
    case AppStore
}

public struct Config {
    // This is private because the use of 'appConfiguration' is preferred.
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    
    // This can be used to add debug statements.
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var appConfiguration: AppConfiguration {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
}
