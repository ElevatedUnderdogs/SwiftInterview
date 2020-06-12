//
//  UIStoryboard.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    
    func viewController<T: UIViewController>() -> T {
        if let viewController = instantiateViewController(withIdentifier: T.storyboardID) as? T {
            return viewController
        } else {
            fatalError("Make sure the storyboard id matches the viewController being used in storyboard, and that its on the table view or registered")
        }
    }
}
