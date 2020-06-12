//
//  UIGestureRecognizer.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension UIGestureRecognizer {
    
    func touchIsLocated(in view: UIView) -> Bool {
        let index = numberOfTouches - 1
        let point = location(ofTouch: index, in: view)
        return point.x > 0 && point.y > 0 && point.x < view.frame.maxX && point.y < view.frame.maxY
    }
}
