//
//  UIApplication.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import UIKit

public extension UIApplication.State {
    var isNotActive: Bool {
        return self != .active
    }
}


public extension UIApplication {
    
    func open(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func registerDefaultNotificationSettings() {
        guard #available(iOS 10.0, *) else {
            UIApplication.shared.registerUserNotificationSettings(
                UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            )
            return
        }
    }
    
    func deeplinkToSettings() {
        guard let appSettings = URL(string: UIApplication.openSettingsURLString) else { return }
        open(appSettings)
    }
    
    static var topMostViewController: UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        if topController == nil {
            print("Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return topController
    }

}
