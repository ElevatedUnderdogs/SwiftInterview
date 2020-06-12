//
//  CGFloat.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension CGFloat {
    
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    var oppositePercent: CGFloat {
        return 1 - self
    }
    
    var capAt100Percent: CGFloat {
        if self > 1 { return 1 }
        return self
    }
    
    func capped(at cap: CGFloat) -> CGFloat {
        if self > cap { return cap }
        return self
    }
    
    static func lowerOfTheTwo(_ first: CGFloat, _ second: CGFloat) -> CGFloat {
        return first > second ? second : first
    }
    
    func isWithin(_ button: UIButton) -> Bool {
        return self < button.frame.maxX && self > button.frame.minX
    }
}

