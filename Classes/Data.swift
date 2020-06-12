//
//  Data.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation

public extension Data {
    
    init?(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) {
        self.init()
        if let parameters = parameters {
            for (key, value) in parameters {
                appendString(string: "--\(boundary)\r\n")
                appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                appendString(string: "\(value)\r\n")
            }
        }
        let filename = "123display_.jpeg"
        let mimetype = "image/jpeg"
        appendString(string: "--\(boundary)\r\n")
        guard let fileKey = filePathKey else { return nil }
        appendString(string: "Content-Disposition: form-data; name=\"\(fileKey)\"; filename=\"\(filename)\"\r\n")
        appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        append(imageDataKey as Data)
        appendString(string: "\r\n")
        appendString(string: "--\(boundary)--\r\n")
    }
    
    var string: String {
        return map {String(format: "%02.2hhx", $0)}.joined()
    }
    
    mutating func appendString(string: String) {
        guard let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true) else { return }
        append(data)
    }
    
    var serialized: [String: Any]? {
        do {
            if let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
                return json
            }
        } catch let error {
            print("Error: ", error.localizedDescription, "for serializing: line: \(#line)")
        }
        return nil
        
    }
    
    var jsonDictionary: [String: Any]? {
        do {
            guard let unwrappedJson = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else {
                print("Warning: we were able to serialize the json but not cast it a [String: Any]...This would seem imposible without catching an error.")
                return nil
            }
            return unwrappedJson
        } catch let err {
            print("Error: ", err.localizedDescription, "for line: \(#line)")
            return nil
        }
    }
}
