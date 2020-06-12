//
//  Bool.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit


public extension Bool {
    var successStr: String {
        return self ? "successful" : "failed"
    }
    
    var yesNo: String {
        return self ? "yes" : "no"
    }
    
    var strInt: String {
        return self == true ? "1" : "0"
    }
    
    ///Returns 1 if true, 0 if false
    var int: Int {
        return self ? 1 : 0
    }
    
    ///Returns 1.0 if true, 0.0 if false
    var float: CGFloat {
        return self ? 1.0 : 0.0
    }
}
