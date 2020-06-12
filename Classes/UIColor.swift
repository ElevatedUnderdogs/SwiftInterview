//
//  UIColor.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation
import UIKit

public extension UIColor {
    
    class var random: UIColor {
        return UIColor(
            red: .random,
            green: .random,
            blue: .random,
            alpha: 1.0
        )
    }
}
