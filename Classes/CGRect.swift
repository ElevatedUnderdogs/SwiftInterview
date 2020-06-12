//
//  CGRect.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit


public extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: minX + (maxX - minX) / 2, y: minY + (maxY - minY) / 2)
    }
    
    var percentAboveTopLip: CGFloat {
        return -1 * minY / height
    }
    
    var isBelowTopLip: Bool {
        return minY >= 0
    }
}
