//
//  Array.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

infix operator ???

public extension Array {
    
    // MARK - access
    
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
    
    var secondToLast: Element?  {
        let index = count - 2
        return self[safe: index]
    }
    
    // MARK - mutating
    
    mutating func pullFirst() -> Element? {
        if isEmpty { return nil }
        return removeFirst()
    }
    
    mutating func swap(last: Int = 0, for element: Element) {
        if count == 0 {
            self = [element]
            return
        }
        for  _ in 0...last  {
            _ = popLast()
        }
        append(element)
    }
    
    // MARK - init
    
    init?(data: Data) {
        guard data.count % MemoryLayout<Element>.size == 0 else { return nil }
        
        let elementCount = data.count / MemoryLayout<Element>.size
        let buffer = UnsafeMutableBufferPointer<Element>.allocate(capacity: elementCount)
        let _ = data.copyBytes(to: buffer)
        
        self = buffer.map({$0})
        buffer.deallocate()
    }
    
    // MARK - computed
    
    var data: Data {
        return self.withUnsafeBufferPointer { pointer in
            return Data(buffer: pointer)
        }
    }
    
    var lastIndex: Int {
        return count - 1
    }
    
    ///Returns the second value when empty
    static func ???(lhs: Array, rhs: Array) -> Array {
        if lhs.isEmpty {
            return rhs
        } else {
            return lhs
        }
    }
}


public extension Array where Element == Any {
    var asText: String {
        var texts: String = ""
        for element in self {
            texts.append(String(describing: element) + "\n" + "-".times(30).joined() + "\n")
        }
        return texts
    }
}
