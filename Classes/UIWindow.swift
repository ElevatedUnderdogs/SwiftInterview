//
//  UIWindow.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation
import UIKit

public extension UIWindow {
    
    func setRoot(as viewController: UIViewController) {
        rootViewController = viewController
        makeKeyAndVisible()
    }
    
    
    var topMostViewController: UIViewController? {
        guard let rootViewController = self.rootViewController else {
            return nil
        }
        return topViewController(for: rootViewController)
    }
    
    func topViewController(for rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        guard let presentedViewController = rootViewController.presentedViewController else {
            return rootViewController
        }
        switch presentedViewController {
        case is UINavigationController:
            let navigationController = presentedViewController as? UINavigationController
            return topViewController(for: navigationController?.viewControllers.last)
        case is UITabBarController:
            let tabBarController = presentedViewController as? UITabBarController
            return topViewController(for: tabBarController?.selectedViewController)
        default:
            return topViewController(for: presentedViewController)
        }
    }
    
    var navigationController: UINavigationController {
        if let navController =  UIApplication.shared.windows[0].rootViewController as? UINavigationController {
            return navController
        } else {
            let navController = UINavigationController()
            navController.setNavigationBarHidden(true, animated: false)
            setRoot(as: navController)
            return navController
        }
    }
}
