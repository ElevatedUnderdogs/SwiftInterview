//
//  URL+HELPERS.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/1/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation


public extension URL {
    
    func getJSON(_ jsonAction: DictionaryAction? = nil) {
        sessionDataTask(provideJSON: jsonAction)?.resume()
    }
    
    func getString(_ stringAction: StringAction? = nil) {
        sessionDataTask(provideString: stringAction)?.resume()
    }
    
    @available(*, deprecated)
    func get(line: Int = #line, file: String = #file, _ jsonAction: URLSession.JSONAction? = nil) {
        return URLSession.dataTask(
            with: self,
            line: line,
            file: file,
            jsonAction: jsonAction
        )
    }
    
    func sessionDataTask(provideString: StringAction?) -> URLSessionDataTask? {

        return URLSession.shared.dataTask(with: self) {
            data, response, error in
            guard let data = data,
                error == nil,
                let document = String(data: data, encoding: .utf8) else {
                print("ERROR: data was nil for the call from: \(self), ")
                provideString?("")
                return
            }
            provideString?(document)
        }
    }
    
    func sessionDataTask(provideJSON: DictionaryAction?) -> URLSessionDataTask? {

        return URLSession.shared.dataTask(with: self) {
            data, response, error in
            guard let data = data else {
                print("ERROR: data was nil for the call from: \(self), ")
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Warning: we were able to serialize the json but not cast it a [String: Any]...This would seem imposible without catching an error.")
                    return
                }
                provideJSON?(json)
            } catch let err {
                print(err.localizedDescription, "for url: \(self)")
                provideJSON?([:])
            }
        }
    }
}

public extension URLRequest {
    
    func get(line: Int = #line, file: String = #file, _ jsonAction: URLSession.JSONAction? = nil) {
        return URLSession.dataTask(
            with: self,
            line: line,
            file: file,
            jsonAction: jsonAction
        )
    }
}


public extension URLSession {
    typealias JSONAction = ([String: Any]?) -> Void
    
    ///usage: `URLSession.dataTask(with: "myurl") { json in }
    static func dataTask(with url: URL, line: Int = #line, file: String = #file, jsonAction: JSONAction? = nil) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            let json = [String: Any](data, response, error, line, file, url.absoluteString)
            jsonAction?(json)
        }
    }
    
    ///usage: `URLSession.dataTask(with: "myurlRequest") { json in }
    static func dataTask(with urlRequest: URLRequest, line: Int = #line, file: String = #file, jsonAction: JSONAction? = nil) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let json = [String: Any](data, response, error, line, file, urlRequest.url?.absoluteString ?? "no url in request")
            jsonAction?(json)
        }
    }
}

public extension Dictionary where Key == String, Value == Any {
    
    init?(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?, _ line: Int, _ file: String, _ urlString: String) {
        guard let data = data else {
            print("ERROR: data was nil for the call from: \(urlString), ")
            return nil
        }
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Warning: we were able to serialize the json but not cast it a [String: Any]...This would seem imposible without catching an error.")
                return nil
            }
            self = json
        } catch let err {
            print("file: \(file) \n", "line: \(line)", err.localizedDescription, "for \(urlString)")
            return nil
        }
    }
}
