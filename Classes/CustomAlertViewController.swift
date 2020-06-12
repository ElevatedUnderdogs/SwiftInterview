//
//  CustomAlertViewController.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import UIKit
import CoreLocation
import UserNotifications

/*
 ________________________
 |                       |
 |                       |
 |    __alertContainer   |
 |    |              |   |
 |    |              |   |
 |    | contentView  |   |   <------ AlertView
 |    |              |   |
 |    |              |   |
 |    |______________|   |
 |    |              |   |
 |    |___buttonStack|   |
 |                       |
 |_______________________|
 
 */
//UIButton.SimpleButton
public extension UIButton {
    
    struct SimpleModel {
        var title: String
        var action: Action?
        
        init(title: String, action: Action? = nil) {
            self.title = title
            self.action = action
        }
    }
}

public extension AlertViewController {
    
    struct model {
        var title: String
        var message: String
    }
}




public class AlertViewController<Payload>: UIViewController {
    
    // MARK - types
    
    enum RequestAuthorization {
        case apns, location
    }
    
    // MARK - properties
    
    let innerWholeAlertContainer = UIView()
    let outerWholeAlertContainer = UIView()
    let buttonStack = AlertButtonsStack()
    var payload: Payload?
    let transitionDuration: TimeInterval = 0.11
    let containerWidth: CGFloat = 300
    
    private var contentsView: UIView! {
        didSet {
            innerWholeAlertContainer.addSubview(contentsView)
            contentsView.constraints(
                firstHorizontal: .distanceToLeading(
                    innerWholeAlertContainer.leadingAnchor, 0
                ),
                secondHorizontal: .distanceToTrailing(
                    innerWholeAlertContainer.trailingAnchor, 0
                ),
                vertical: .distanceToTop(
                    innerWholeAlertContainer.topAnchor, 0
                ),
                secondVertical: .distanceToBottom(
                    buttonStack.topAnchor, 0
                )
            )
        }
    }
    
    // MARK - computed
    
    private func standardizeButtonsWithDismissAction(models: [UIButton.SimpleModel]) -> [UIButton.Model] {
        var buttonModelsToAdd: [UIButton.Model] = []
        let count = models.count
        for (inde, model) in models.enumerated() {
            var borders: [UIView.BorderModel] = []
            if count > 2 || count == 1 {
                borders.append(
                    UIView.BorderModel(
                        color: .lightGray,
                        width: 1,
                        edges: [.top]
                    )
                )
            } else if count == 2 {
                if inde == 0 {
                    borders.append(
                        UIView.BorderModel(
                            color: .lightGray,
                            width: 1,
                            edges: [.top]
                        )
                    )
                } else if inde == 1 {
                    borders.append(
                        UIView.BorderModel(
                            color: .lightGray,
                            width: 1,
                            edges: [.left, .top]
                        )
                    )
                }
            }
            buttonModelsToAdd.append(
                UIButton.Model(
                text: model.title,
                color: .white,
                textColor: .darkGray,
                borders: borders
                ) {
                    model.action?()
                    self.dismissAlert()
            })
        }
        return buttonModelsToAdd
    }
    
    // MARK - styles
    
    func styleNoButtons(regularContentsModel: RegularContentsView.Model) {
        initialSetup()
        let alertContentView = RegularContentsView()
        alertContentView.model = regularContentsModel.forContainer(width: containerWidth)
        contentsView = alertContentView
        setButtonConstraints()
    }
    
    
    func styleAsOkayAlert(regularContentsModel: RegularContentsView.Model, action: Action? = nil) {
        initialSetup()
        let alertContentView = RegularContentsView()
        alertContentView.model = regularContentsModel.forContainer(width: containerWidth)
        contentsView = alertContentView
        
        let okayModel = standardizeButtonsWithDismissAction(
            models: [
                UIButton.SimpleModel(
                    title: "Okay, I got it.",
                    action: action
                )
            ]
        )
        buttonStack.buttonModels(okayModel)
        setButtonConstraints()
    }
    
    func styleCancelAlert(regularContentsModel: RegularContentsView.Model, models: UIButton.SimpleModel...) {
        initialSetup()
        let alertContentView = RegularContentsView()
        alertContentView.model = regularContentsModel.forContainer(width: containerWidth)
        contentsView = alertContentView
        
        var models = models
        models.append(UIButton.SimpleModel(title: "Cancel"))
        let newButtonModels = standardizeButtonsWithDismissAction(models: models)
        buttonStack.buttonModels(newButtonModels)
        setButtonConstraints()
    }
    
    func styleRegular(regularContentsModel: RegularContentsView.Model, models: UIButton.SimpleModel...) {
        self.styleRegular(
            regularContentsModel: regularContentsModel,
            models: models
        )
    }
    
    func styleRegular(regularContentsModel: RegularContentsView.Model, models: [UIButton.SimpleModel]) {
        initialSetup()
        
        let alertContentView = RegularContentsView()
        alertContentView.model = regularContentsModel.forContainer(width: containerWidth)
        contentsView = alertContentView
        
        let newButtonModels = standardizeButtonsWithDismissAction(models: models)
        buttonStack.buttonModels(newButtonModels)
        setButtonConstraints()
    }
    
    
    // MARK - create and show bad connection alert
    
    static func showBadConnectionAlert() {
        DispatchQueue.main.async {
            let alertViewController = AlertViewController<Any>()
            alertViewController.styleAsOkayAlert(
                regularContentsModel: RegularContentsView.Model(
                    title: "Weak connection",
                    message: "We're sorry the network connection is weak.  Perhaps try reconnecting your wifi."
                )
            ) {}
            UIApplication.topMostViewController?.safelyPresent(alertViewController)
        }
    }

    
    // MARK - generic failure create/show alert
    
    static func alertFailure(message: String) {
        safelyAlert(
            controllerTitle: "We're sorry",
            message: message,
            actionTitle: "Okay"
        )
    }
    
    // MARK - generic create/show alert
    
    static func safelyAlert(
        controllerTitle: String,
        message: String,
        actionTitle: String,
        actionClosure: Action? = nil
        ) {
        DispatchQueue.main.async {
            let alertViewController = AlertViewController<Any>()
            let yourAction = UIButton.SimpleModel(title: actionTitle, action: {
                actionClosure?()
            })
            alertViewController.styleRegular(
                regularContentsModel: RegularContentsView.Model(
                    title: controllerTitle,
                    message: message
                ),
                models: [yourAction])
        }
    }
    
    // MARK - lifecycle
    
    func dismissAlert() {
        UIView.animate(withDuration: transitionDuration, animations: {
            self.view.alpha = 0
        }) { completed in
            self.safelyDissmiss(animated: false)
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        outerWholeAlertContainer.layer.applySketchShadow()
        innerWholeAlertContainer.roundCorners(constant: 15)
        UIView.animate(withDuration: transitionDuration, animations: {
            self.view.alpha = 1
        })
    }
    
    // MARK - universal setup
    
    
    fileprivate func initialSetup() {
        view.alpha = 0
        modalPresentationStyle = .overFullScreen
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(outerWholeAlertContainer)
        outerWholeAlertContainer.addSubview(innerWholeAlertContainer)
        outerWholeAlertContainer.pinToEdges(innerWholeAlertContainer)
        innerWholeAlertContainer.backgroundColor = .white
        innerWholeAlertContainer.addSubview(buttonStack)
        outerWholeAlertContainer.constraints(
            .horizontal(.centeredHorizontallyWith(view)),
            .vertical(.centeredVerticallyTo(view)),
            .horizontal(.width(containerWidth))
        )
    }
    
    func setButtonConstraints() {
        buttonStack.constraints(
            .horizontal(
                .distanceToLeading(innerWholeAlertContainer.leadingAnchor, 0)
            ),
            .horizontal(
                .distanceToTrailing(innerWholeAlertContainer.trailingAnchor, 0)
            ),
            .vertical(
                .distanceToBottom(innerWholeAlertContainer.bottomAnchor, 0)
            )
        )
    }
    
    // MARK - create alert
    
    
    static func resetEmailSent(_ completion: @escaping Action) -> AlertViewController<Any> {
        let alertViewController = AlertViewController<Any>()
        alertViewController.styleRegular(
            regularContentsModel: RegularContentsView.Model(
              title: "We sent a reset link to your email"
            ),
            models: UIButton.SimpleModel(
                title: "Okay",
                action: completion
            )
        )
        return alertViewController
    }
}
