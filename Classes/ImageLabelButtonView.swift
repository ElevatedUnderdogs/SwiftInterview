//
//  ImageLabelButtonView.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import UIKit

/*
 ===============
 |              |
 |     img      |
 |______________|
 _______________
 |_____label____|
 
 ================
 |_____button___|
 */

//protocol ImageLabelButtonViewStyleAble {
//    var model: ImageLabelButtonViewModel { get }
//}

public struct ImageLabelButtonViewModel {
    var image: UIImage?
    var message: String?
    var buttonText: String?
    var buttonAction: Action?
    
    static var empty: ImageLabelButtonViewModel {
        return ImageLabelButtonViewModel(
            image: nil,
            message: nil,
            buttonText: nil,
            buttonAction: nil
        )
    }
}


///Height is determined by subviews so you only need 3 constraints, 2 horizontal and one vertical constraint.
public class ImageLabelButtonView: UIView {
    
    // MARK - properties
    
    var style: ImageLabelButtonViewModel? {
        didSet {
            guard let newStyle = style else { return }
            style(as: newStyle)
            buttonAction = newStyle.buttonAction
        }
    }
    
    var imageView = UIImageView()
    var label = UILabel()
    var button = UIButton()
    var buttonAction: Action? { didSet { setupView() } }
    var margin: CGFloat = 27.19 { didSet { setupView() } }
    var imageViewHeight: CGFloat = 71.92 { didSet { setupView() } }
    var buttonHeight: CGFloat = 44 { didSet { setupView() } }
    var buttonCornerRadius: CGFloat { return buttonHeight / 2 }
    
    // MARK - view lifecycle
    
    func viewDidAppear() {
        guard let theStyle = style else { return }
        style(as: theStyle)
    }
    
    // MARK - conformance
    
    func updateAkinConstraints() {}
    
    // MARK - actions
    
    func buttonAction(_ action: @escaping Action) {
        self.buttonAction = action
    }
    
    @objc func buttonTapped() {
        buttonAction?()
    }
    
    // MARK - init
    
    ///Must manually set the width of the imageLabelButtonStyleView.
    convenience init(style imageLabelButtonViewStyle: ImageLabelButtonViewModel) {
        self.init()
        style(as: imageLabelButtonViewStyle)
        generalStyle()
    }
    
    // MARK - style
    
    func generalStyle() {
        button.titleLabel?.font = button.titleLabel?.font.withSize(18)
        label.font = label.font.withSize(18)
        button.makeCircularClips()
    }
    
    func style(as model: ImageLabelButtonViewModel) {
        imageView.image = model.image
        if let imageViewHeight = imageView.constraints.first(of: .height) {
            imageViewHeight.constant = model.image == nil ? 0 : self.imageViewHeight
        }
        if let buttonHeight = button.constraints.first(of: .height) {
            buttonHeight.constant = model.buttonText == nil ? 0 : self.buttonHeight
        }
        label.set(attributed: model.message?.akinCellStyle, with: .designerAlignment)
        button.setTitle(model.buttonText)

        label.textColor = .darkGray
    }
    
    func setupView() {
        
        backgroundColor = .clear
        
        imageView.backgroundColor = .clear
        addSubview(imageView)
        
        label.backgroundColor = .clear
        addSubview(label)
        
        addSubview(button)
        
        imageView.constraints(
            firstHorizontal: .distanceToTrailing(trailingAnchor, 0),
            secondHorizontal: .distanceToLeading(leadingAnchor, 0),
            vertical: .distanceToTop(topAnchor, 0),
            secondVertical: .height(imageViewHeight)
        )
        
        label.constraints(
            firstHorizontal: .distanceToTrailing(trailingAnchor, 0),
            secondHorizontal: .distanceToLeading(leadingAnchor, 0),
            vertical: .distanceToTop(imageView.bottomAnchor, margin),
            secondVertical: .distanceToBottom(button.topAnchor, margin)
        )
        
        button.constraints(
            firstHorizontal: .distanceToTrailing(trailingAnchor, 0),
            secondHorizontal: .distanceToLeading(leadingAnchor, 0),
            vertical: .distanceToTop(label.bottomAnchor, 0),
            secondVertical: .distanceToBottom(bottomAnchor, 0)
        )
        
        button.constraint(from: .height(buttonHeight))
        
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        button.layer.cornerRadius = buttonCornerRadius
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}
