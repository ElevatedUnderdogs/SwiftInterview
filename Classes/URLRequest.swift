//
//  URLRequest.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/1/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation
import UIKit

public typealias DictionaryAction = ([String: Any]) -> Void

public extension URLRequest {
    
    func post(_ jsonAction: DictionaryAction? = nil) {
        get(jsonAction)
    }
    
    init?(img: UIImage, url: URL) {
        self.init(url: url)
        httpMethod = "GET"
        let boundary: String = .generateBoundaryString
        setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        guard let imgData = img.jpegData(compressionQuality: 1.0) else { return }
        httpBody = Data(
            parameters: nil,
            filePathKey: "userfile",
            imageDataKey: imgData,
            boundary: boundary
        )
    }

    
    func get(_ jsonAction: DictionaryAction? = nil) {
        guard !sockaddr_in.isConnectedToNetwork else {
            AlertViewController<Any>.showBadConnectionAlert()
            return
        }
        
        URLSession.shared.dataTask(self) { json in
            jsonAction?(json)
        }
    }
    
}
