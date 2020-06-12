//
//  Math+Power^.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }

infix operator ^ : PowerPrecedence

public func ^ (radix: Double, power: Double) -> Double {
    return pow(radix, power)
}
