//
//  CGPoint.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension CGPoint {
    
    func x(increment: CGFloat) -> CGPoint {
        let newx = x + increment
        return CGPoint(x: newx, y: y)
    }
    
    func wy(increment: CGFloat) -> CGPoint {
        let newy = y + increment
        return CGPoint(x: x, y: newy)
    }
}

