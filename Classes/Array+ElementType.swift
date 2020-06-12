//
//  Array+ElementType.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension Array where Element == UIView {
    func printFrames() {
        for v in self {
            Swift.print(v.frame)
        }
    }
}





public extension Array where Element: Equatable {
    
    mutating func remove(_ element: Element) {
        if !self.contains(element) { return }
        self = self.filter { $0 != element }
    }
    
    mutating func appendIfUnique(_ element: Element) {
        if !contains(element) {
            append(element)
        }
    }
    
    mutating func appendUnique(contentsOf contents: [Element]) {
        for element in contents {
            self.appendIfUnique(element)
        }
    }
    
    mutating func remove(element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
}


public extension Array where Element == String {
    var asString: String {
        var string = ""
        for element in self {
            string.append(" " + element)
        }
        return string
    }
}

public extension Array where Element == Int {
    var strings: [String] {
        return map { String($0) }
    }
}

public extension Array where Element == UIButton {
    
    @discardableResult
    func makeCircular() -> [UIButton] {
        forEach { $0.makeCircularClips() }
        return self
    }
    
    @discardableResult
    func applyShadow() -> [UIButton] {
        forEach { $0.layer.applySketchShadow() }
        return self
    }
}


public extension Array where Element == NSLayoutConstraint {
    
    func first(of type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return first { $0.firstAttribute == type && $0.relation == .equal }
    }
}


public extension Array where Element: Hashable & Equatable {
    
    var uniqueOrdered: [Element] {
        var buffer: [Element] = []
        var added = Set<Element>()
        for element in self where !added.contains(element) {
            added.insert(element)
            buffer.append(element)
        }
        return buffer
    }
}
