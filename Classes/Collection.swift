//
//  Collection.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation

public extension Collection {
    
    var json: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Error: Can't create string with data. line: \(#line), file: \(#file)")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("Error: json serialization error: \(parseError)")
            return "{}"
        }
    }
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    var hasExactlyOne: Bool {
        return count == 1
    }
}

