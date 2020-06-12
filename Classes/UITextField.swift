//
//  UITextField.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension UITextField {
    
    func increaseFontSize() {
        guard let size = self.font?.pointSize,
            let name = self.font?.fontName,
            let font = UIFont(name: name, size: size + 2) else { return }
        self.font = font
    }
}
