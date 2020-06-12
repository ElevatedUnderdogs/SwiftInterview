//
//  Observable.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation


public struct Observable<Value> {
    
    var value: Value {
        didSet {
            bind?(value)
        }
    }
    typealias ValueAction = (Value) -> Void
    var bind: ((Value) -> Void)?
    
    init(_ value: Value) {
        self.value = value
    }
}
