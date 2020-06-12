//
//  UITextView.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension UITextView {
    var hasText: Bool {
        return text != nil
    }
    
    func resetTintColor() {
        let color = tintColor
        tintColor = .clear
        tintColor = color
    }
    
    func indexFrom(_ tvs: [UITextView]) -> Int? {
        for (i, tv) in tvs.enumerated() where tv == self  {
            return i
        }
        return nil
    }
}
