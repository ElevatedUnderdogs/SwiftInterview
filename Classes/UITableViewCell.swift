//
//  UITableViewCell.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension UITableViewCell {
    
    static var reuseID: String {
        return String(describing: self)
    }
}
