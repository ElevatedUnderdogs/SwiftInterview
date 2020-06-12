//
//  UIButton.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public enum Side {
    case left, right
}

public protocol Targetable: UIView {
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event)
}

extension UIButton: Targetable {
    
    // MARK - set color
    
    func set(color: UIColor) {
        let img = imageView?.image?.withRenderingMode(.alwaysTemplate)
        setImage(img, for: .normal)
        tintColor = color
    }
    
    // MARK - set image
    
    func safelySetImage(_ image: UIImage?, for state: UIControl.State = .normal) {
        DispatchQueue.main.async {
            self.setImage(image, for: state)
        }
    }
    
    func downloadImageFrom(link: String)  {
        guard let nsurl = NSURL(string:link) else {
            print("unable to convert string to nsurl: \(link)")
            return
        }
        URLSession.shared.dataTask( with: nsurl as URL, completionHandler: {
            data, response, error in
            if let err = error {
                print("Error: ", err, Date())
            }
            DispatchQueue.main.async {
                guard error == nil else { return }
                self.setImage(nil, for: .normal)
                self.contentMode = .scaleAspectFill
                if let data = data {
                    self.setImage(UIImage(data: data), for: .normal)
                }
            }
        }).resume()
    }
    
    func round(side: Side, constant: CGFloat = 5) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: side == .left ? [
                .topLeft,
                .bottomLeft
                ] : [
                    .topRight,
                    .bottomRight
            ],
            cornerRadii: CGSize(width: constant, height: constant)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    func setCircleView( _ img: UIImage, inset: CGFloat) {
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        makeCircularClipsMask()
        layer.applySketchShadow()
        let img = img.withRenderingMode(.alwaysTemplate)
        setImage(img, for: .normal)
        tintColor = .white
        imageEdgeInsets = UIEdgeInsets(
            top: inset,
            left: inset,
            bottom: inset,
            right: inset
        )
    }
    
    // MARK - init
    
    convenience init(_ model: Model) {
        self.init()
        accessibilityIdentifier = model.accessibilityID
        backgroundColor = model.color
        setTitleColor(model.textColor, for: .normal)
        setTitle(model.text)
    }
    
    // MARK - style
    
    
    func glow(with color: UIColor) {
        layer.backgroundColor = color.cgColor
        layer.applySketchShadow(color: color, alpha: 0.7, y: 3)
    }
    
    
    // MARK - set title
    
    func setTitle(_ title: String?) {
        setTitle(title, for: .normal)
    }
}



public extension UIButton {
    
    struct Model {
        var text: String
        var action: Action
        var color: UIColor
        var textColor: UIColor
        var borders: [BorderModel]
        
        var accessibilityID: String {
            return text
        }
        
        init(text: String, color: UIColor, textColor: UIColor, borders: BorderModel..., action: @escaping Action) {
            self.init(text: text, color: color, textColor: textColor, borders: borders, action: action)
        }
        
        init(text: String, color: UIColor, textColor: UIColor, borders: [BorderModel], action: @escaping Action) {
            self.text = text
            self.color = color
            self.action = action
            self.textColor = textColor
            self.borders = borders
        }
    }
}
