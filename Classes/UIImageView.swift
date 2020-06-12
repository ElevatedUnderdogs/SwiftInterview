//
//  UIImageView.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    
    // MARK - download image
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloadImageFrom(link: String)  {
        guard let nsurl = NSURL(string:link) else {
            print("could not convert link to nsurl")
            return
        }
        URLSession.shared.dataTask( with: nsurl as URL, completionHandler: {
            data, response, error in
            if let err = error {
                print("Error: ", err, Date())
            }
            DispatchQueue.main.async {
                self.image = nil
                self.contentMode = .scaleAspectFill
                if let data = data {
                    self.image = UIImage(data: data)
                }
            }
        }).resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    // MARK - set color
    
    
    func set(color: UIColor) {
        image = image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }
    
    // MARK - add separator
    
    func addLeftSeparator(with color: UIColor) {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        separator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.topAnchor.constraint(
            equalTo: topAnchor,
            constant: 0.2
        ).isActive = true
        separator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.backgroundColor = color
    }
}


