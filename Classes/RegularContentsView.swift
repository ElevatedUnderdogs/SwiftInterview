//
//  RegularContentsView.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import UIKit

/*
 
 ___________________
 |                  |
 |    image         |
 |                  |
 ___________________
 |                  |
 |     Title        |
 |                  |
 ___________________
 |                  |
 |     Message      |
 |                  |
 ___________________
 
 */

public extension RegularContentsView {
    
    struct Model {
        var image: UIImage?
        var title: String?
        var message: String?
        var margin: CGFloat
        var containerWidth: CGFloat?
        
        init(image: UIImage? = nil, title: String? = nil, message: String? = nil, margin: CGFloat = 10, containerWidth: CGFloat? = nil) {
            self.image = image
            self.title = title
            self.message = message
            self.margin = margin
            self.containerWidth = containerWidth
        }
        
        func forContainer(width: CGFloat) -> Model {
            var model = self
            model.containerWidth = width
            return model
        }
    }
}



public class RegularContentsView: UIStackView {
    
    
    var model: Model! {
        didSet {
            axis = .vertical
            removeAllArrangedSubViews()
            
            if let image = model.image {
                let imageView = UIImageView()
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
                imageView.accessibilityIdentifier = "Alert Image View"
                if let containerWidth = model.containerWidth {
                    let height = image.size.proportionalHeight(
                        for: containerWidth
                    )
                    imageView.constraint(from: .height(height))
                } else {
                    print("warning: Should provide a container width if you provide an image. Line: \(#line)")
                }
                addArrangedSubview(imageView)
            }
            
            if let title = model.title {
                let labelContainer = UIView()
                let label = UILabel()
                labelContainer.addSubview(label)
                label.constraints(
                    firstHorizontal: .distanceToLeading(
                        labelContainer.leadingAnchor, model.margin
                    ),
                    secondHorizontal: .distanceToTrailing(
                        labelContainer.trailingAnchor,
                        model.margin
                    ),
                    vertical: .distanceToTop(
                        labelContainer.topAnchor, model.margin + 10
                    ),
                    secondVertical: .centeredVerticallyTo(
                        labelContainer
                    )
                )
                label.set(text: title)
                labelContainer.accessibilityLabel = "title container"
                
                let fontsize = label.font.pointSize
                label.font = label.font.withSize(fontsize + 5)
                label.numberOfLines = 0
                label.applyTextStyle()
                label.accessibilityIdentifier = "Alert title label"
                label.accessibilityValue = label.text
                addArrangedSubview(labelContainer)
            }
            
            if let message = model.message {
                let messageContainer = UIView()
                let label = UILabel()
                messageContainer.addSubview(label)
                label.constraints(
                    firstHorizontal: .distanceToLeading(
                        messageContainer.leadingAnchor, model.margin
                    ),
                    secondHorizontal: .distanceToTrailing(
                        messageContainer.trailingAnchor, model.margin
                    ),
                    vertical: .distanceToTop(
                        messageContainer.topAnchor, model.margin
                    ),
                    secondVertical: .distanceToBottom(
                        messageContainer.bottomAnchor, model.margin + 15
                    )
                )
                label.set(text: message)
                label.numberOfLines = 0
                label.applyTextStyle()
                label.accessibilityIdentifier = "Alert message label"
                label.accessibilityValue = label.text
                addArrangedSubview(messageContainer)
            }
        }
    }
}
