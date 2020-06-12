//
//  UINavigationController.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation
import UIKit


public extension UINavigationController {
    
    // MARk - moving view Controllers
    
    func safelyPopViewController(animated: Bool = true) {
        DispatchQueue.main.async {
            self.popViewController(animated: animated)
        }
    }
    
    func safelyPush(_ viewController: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            self.pushViewController(viewController, animated: animated)
        }
    }
    
    @discardableResult
    func safelyPopTo<T: UIViewController>() -> T? {
        let lastindex = viewControllers.count - 1
        for index in lastindex...0 {
            if let viewControllerToShow = viewControllers[index] as? T {
                return viewControllerToShow
            } else {
                safelyPopViewController()
            }
        }
        return nil
    }
    
    func add(viewController: UIViewController, animated: Bool = true) {
        if viewControllers.isEmpty {
            viewControllers = [viewController]
        } else {
            safelyPush(viewController, animated: animated)
        }
    }
    
    func remove(_ viewController: UIViewController?) {
        DispatchQueue.main.async {
            guard let vc = viewController,
                let index = self.viewControllers.firstIndex(of: vc) else { return }
            self.viewControllers.remove(at: index)
        }
    }
    
    var safelyPopViewControllerAnd: UIViewController? {
        safelyPopViewController(animated: true)
        return secondTopMostViewController
    }
    
    
    ///Lets the last one be on the top.
    func safelyPush(_ inViewControllers: [UIViewController], animated: Bool = true) {
        DispatchQueue.main.async {
            var stack = self.viewControllers
            stack.append(contentsOf: inViewControllers)
            self.setViewControllers(stack, animated: animated)
        }
    }
    
    func insertUnderTop(viewControllersToInsert: [UIViewController], animated: Bool) {
        let controllers = viewControllers
        guard !controllers.isEmpty else { return }
        let last = self.viewControllers.removeLast()
        self.viewControllers.append(contentsOf: viewControllersToInsert)
        self.viewControllers.append(last)
        self.setViewControllers(self.viewControllers, animated: animated)
        
    }
    
    func backToViewController(vc: Any) {
        for element in viewControllers where "\(type(of: element)).Type" == "\(type(of: vc))" {
            popToViewController(element, animated: true)
        }
    }
    
    // MARK - view controller access
    
    var secondTopMostViewController: UIViewController? {
        let count = viewControllers.count
        if count > 1 {
            return viewControllers[count - 2]
        } else {
            return nil
        }
    }
}
