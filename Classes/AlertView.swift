//
//  AlertView.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import UIKit

/*
 
 AlertView
 ________________________
 |                       |
 |                       |
 |    __alertContainer   |
 |    |              |   |
 |    |              |   |
 |    | contentView  |   |
 |    |              |   |
 |    |              |   |
 |    |______________|   |
 |    |              |   |
 |    |___buttonStack| <-----------------Alert Button Stack
 |                       |
 |_______________________|
 
 */

public extension Array where Element == Targetable {
    
    init(_ buttonModels: [UIButton.Model]) {
        var buttons: [Targetable] = []
        for buttonModel in buttonModels {
            buttons.append(UIButton.create(buttonModel))
        }
        self = buttons
    }
}

public extension UIButton {
    
    static func create(_ model: UIButton.Model) -> Targetable {
        
        if model.borders.hasElements {
            let buttonContainer = ButtonContainer()
            let button = UIButton(model)
            button.accessibilityIdentifier = model.accessibilityID
            buttonContainer.accessibilityIdentifier = model.accessibilityID + " container"
            buttonContainer.add(button: button)
            buttonContainer.backgroundColor = .yellow
            return buttonContainer
        } else {
            let button = UIButton(model)
            button.accessibilityIdentifier = model.accessibilityID
            return button
        }
    }
}


public class ButtonContainer: UIView, Targetable {
    

    var button: UIButton!
    
    override public var tag: Int {
        get {
            return button.tag
        }
        set {
            button.tag = newValue
        }
    }
    
    func add(button: UIButton) {
        self.button = button
        addSubview(button)
        button.constraints(
            firstHorizontal: .distanceToLeading(leadingAnchor, 0),
            secondHorizontal: .distanceToTrailing(trailingAnchor, 0),
            vertical: .distanceToTop(topAnchor, 0),
            secondVertical: .distanceToBottom(bottomAnchor, 0)
        )
        print(button.accessibilityIdentifier != nil, "The accessibility identifier hasn't been set.\(#line), \(#file)")
    }
    
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button?.addTarget(target, action: action, for: controlEvents)
    }

}



public class AlertButtonsStack: UIStackView {
    
    // MARK - properties
    
    let buttonHeight: CGFloat = 50
    
    private var buttonModels: [UIButton.Model]! {
        didSet {
            let buttons = [Targetable](buttonModels)
            set(buttons: buttons)
            for (inde, button) in buttons.enumerated() {
                button.tag = inde
                button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
                guard let borders = buttonModels?[inde].borders else { return }
                borders.forEach { button.addBorder(model: $0) }
            }
        }
    }
    
    // MARK - setters
    
    func buttonModels(_ buttonModels: [UIButton.Model]) {
        self.buttonModels = buttonModels
    }
    
    func buttonModels(_ buttonModels: UIButton.Model...) {
        self.buttonModels(buttonModels)
    }
    
    private func set(buttons: UIView...) {
        self.set(buttons: buttons)
    }
    
    private func set(buttons: [UIView]) {
        if arrangedSubviews.count > 0 {
            removeAllArrangedSubViews()
        }
        let count = CGFloat(buttons.count)
        buttons.forEach {
            print($0.accessibilityIdentifier != nil, "The button doesn't have any accessibility identifier. ")
            addArrangedSubview($0)
        }
        axis = arrangedSubviews.count > 2 ? .vertical : .horizontal
        buttons.forEach {
            $0.constraint(from: .height(buttonHeight))
            if axis != .vertical {
                $0.constraint(from: .proportionalWidthTo(self, 1.0 / count ))
            }
        }
    }
    
    // MARK - tapped
    
    @objc func tapped(_ button: UIButton) {
        buttonModels[button.tag].action()
    }
}
