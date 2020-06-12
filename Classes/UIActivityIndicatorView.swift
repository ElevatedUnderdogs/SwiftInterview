//
//  UIActivityIndicatorView.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension UIActivityIndicatorView {
    
    func animate(_ shouldAnimate: Bool) {
        DispatchQueue.main.async {
            if shouldAnimate {
                self.startAnimating()
            } else {
                self.stopAnimating()
            }
        }
    }
}
