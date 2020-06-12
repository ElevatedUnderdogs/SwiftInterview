//
//  NSMutableURLRequest.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/1/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit


public extension NSMutableURLRequest {
    
    convenience init?(img: UIImage, url: URL) {
        self.init(url:url)
        httpMethod = "POST"
        let boundary: String = .generateBoundaryString
        setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = img.jpegData(compressionQuality: 0.5)
        if imageData == nil {return nil}
        httpBody = Data(parameters: nil, filePathKey: "userfile", imageDataKey: (imageData! as NSData) as Data, boundary: boundary)
    }
}

