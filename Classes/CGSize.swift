//
//  CGSize.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension CGSize {
    
    func proportionalWidth(for height: CGFloat) -> CGFloat {
        return height * self.width / self.height
    }
    
    func proportionalHeight(for width: CGFloat) -> CGFloat {
        return width * self.height  / self.width
    }
}
