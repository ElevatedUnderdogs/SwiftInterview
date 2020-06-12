//
//  UIDatePicker.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation
import UIKit

public extension UIDatePicker {
    
    func hideSelectionIndicator() {
        for i in [1, 2] {
            self.subviews[i].isHidden = true
        }
    }
}
