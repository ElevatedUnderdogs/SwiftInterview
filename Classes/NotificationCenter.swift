//
//  NotificationCenter.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    
    func post(name aName: String, object anObject: Any? = nil) {
        post(name: NSNotification.Name(rawValue: aName), object: anObject)
    }
    
    func addObserver(_ observer: Any, selector aSelector: Selector, name aName: String, object anObject: Any? = nil) {
        addObserver(
            observer,
            selector: aSelector,
            name: NSNotification.Name(rawValue: aName),
            object: anObject
        )
    }
}
