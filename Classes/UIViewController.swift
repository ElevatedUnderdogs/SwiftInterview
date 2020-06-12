//
//  UIViewController.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public typealias ViewControllerAction = (UIViewController) -> Void

public extension UIViewController {
    
    // MARK - computed property
    
    func the(_ firstView: UIView?,  isAbove second: UIView?) -> Bool {
        guard let cellArrowPoint = firstView?.frame.origin,
            let vcHolderPoint = second?.frame.origin,
            let cellArrowPointinView = firstView?.convert(cellArrowPoint, to: view),
            let vcHolderPointinView = second?.convert(vcHolderPoint, to: view) else { return false }
        var top: CGFloat = 0
        if #available(iOS 11.0, *),
            let safeAreaTopHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            top = safeAreaTopHeight
        }
        return cellArrowPointinView.y < vcHolderPointinView.y - top
    }
    
    var isVisible: Bool {
        return viewIfLoaded?.window != nil
    }
    
    static var storyboardID: String {
        return String(describing: self)
    }
    
    var topMostViewController: UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController
        } else {
            for view in self.view.subviews where view.next is UIViewController {
                return (view.next as? UIViewController)?.topMostViewController ?? self
            }
            return self
        }
    }
    
    // MARK - lock
    
    func synced(_ lock: Any, closure: Action) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    // MARK - navigation
    
    func safelyPerformSegue(with identifier: String, sender: Any?) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    func safelyDissmiss(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.dismiss(animated: flag, completion: completion)
        }
    }
    
    func safelyPresent(_ viewController: UIViewController, animated: Bool = true, completion: Action? = nil) {
        DispatchQueue.main.async {
            self.present(viewController, animated: animated, completion: completion)
        }
    }
}
