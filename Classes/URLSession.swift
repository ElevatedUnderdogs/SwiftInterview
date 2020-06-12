//
//  URLSession.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/1/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public typealias ImageAction = (UIImage?) -> Void

public extension URLSession {
    
    func imageTask(from urlStr: String, completion: @escaping ImageAction) {
        guard let url = URL(string: urlStr) else {return}
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let error = error {
                print("Warning: error was: \(error.localizedDescription) \(#line) \(#file)")
            }
            guard let data = data else {
                print("Server ERROR: data was nil for the call from: \(url), ")
                return
            }
            let image = UIImage(data: data)
            completion(image)
            }.resume()
    }
    
    func dataTask(_ request: URLRequest, _ jsonAction: DictionaryAction? = nil) {
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let error = error {
                AlertViewController<Any>.safelyAlert(
                    controllerTitle: "Error from Server",
                    message: error.localizedDescription,
                    actionTitle: "Okay"
                )
                assert(false)
            }
            guard let json = data?.jsonDictionary else {
                print("Server ERROR: data was nil for the call from: \(String(describing: request.url?.absoluteString)), ")
                return
            }
            jsonAction?(json)
            }.resume()
    }
}
