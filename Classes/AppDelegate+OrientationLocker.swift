//
//  AppDelegate+OrientationLocker.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

// modular
extension AppDelegate {
    
    struct OrientationLocker {
        
        static var orientationLock: UIInterfaceOrientationMask = .all
        
        static func lock(orientation: UIInterfaceOrientationMask) {
            if let _ = UIApplication.shared.delegate as? AppDelegate {
                orientationLock = orientation
            }
        }
        
        static func unlockOrientation() {
            lock(orientation: .all)
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, addRotateTo rotateOrientation: UIInterfaceOrientation) {
            
            self.lock(orientation: orientation)
            
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}
