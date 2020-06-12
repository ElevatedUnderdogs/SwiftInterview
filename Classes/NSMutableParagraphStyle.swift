//
//  NSMutableParagraphStyle.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension NSMutableParagraphStyle {
    
    func setAlighnment(with alignmentStyle: UILabel.AlignmentStyle, numberOfVisibileLines: Int) {
        switch alignmentStyle {
        case .designerAlignment:
            alignment = numberOfVisibileLines <= 3 ? .center : .left
        case .basic(let alignment):
            self.alignment = alignment
        }
    }
}
