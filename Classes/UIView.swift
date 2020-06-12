//
//  UIView.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import UIKit

public struct SpacerContainer {
    var spacer: UIView
    var view: UIView
}


public struct CentipedeModel {
    var first: UIView
    var containers: [SpacerContainer]
}

public extension UIView {
    
    // MARK - round view
    
    func makeCircularClipsMask() {
        layer.masksToBounds = true
        makeCircularClips()
    }
    
    func makeCircularClips() {
        //let width = bounds.size.width
        let height = bounds.size.height
        layer.cornerRadius = 0.5 * height
        clipsToBounds = true
    }
    
    func roundCorners(constant: CGFloat = 5) {
        layer.cornerRadius = constant
        layer.masksToBounds = true
        clipsToBounds = true
    }
    
    func setUpCircleView(_ img: UIImage, inset: CGFloat) {
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        makeCircularClips()
        layer.applySketchShadow()
        let imgView = UIImageView(frame: frame)
        imgView.image = img.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .white
        addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                imgView.heightAnchor.constraint(equalTo: heightAnchor, constant: inset),
                imgView.widthAnchor.constraint(equalTo: widthAnchor, constant: inset),
                imgView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imgView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
        imgView.backgroundColor = .clear
    }
    
    // MARK - style
    
    func glow(color: UIColor = .white) {
        layer.masksToBounds = false
        layer.shadowOffset = .zero
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    // MARK - create borders
    
    struct BorderModel {
        enum Edge {
            case left, right, top, bottom
        }
        
        var color: UIColor
        var width: CGFloat
        var edges: [Edge]
    }
    
    func addBorder(model: BorderModel) {
        for edge in model.edges {
            let border = UIView()
            addSubview(border)
            border.backgroundColor = model.color
            switch edge {
            case .left:
                border.constraints(
                    firstHorizontal: .distanceToLeading(leadingAnchor, 0),
                    secondHorizontal: .width(model.width),
                    vertical: .distanceToTop(topAnchor, 0),
                    secondVertical: .distanceToBottom(bottomAnchor, 0)
                )
            case .right:
                border.constraints(
                    firstHorizontal: .distanceToTrailing(trailingAnchor, 0),
                    secondHorizontal: .width(model.width),
                    vertical: .distanceToTop(topAnchor, 0),
                    secondVertical: .distanceToBottom(bottomAnchor, 0)
                )
            case .top:
                border.constraints(
                    firstHorizontal: .distanceToLeading(leadingAnchor, 0),
                    secondHorizontal: .distanceToTrailing(trailingAnchor, 0),
                    vertical: .height(model.width),
                    secondVertical: .distanceToTop(topAnchor, 0)
                )
            case .bottom:
                border.constraints(
                    firstHorizontal: .distanceToLeading(leadingAnchor, 0),
                    secondHorizontal: .distanceToTrailing(trailingAnchor, 0),
                    vertical: .height(model.width),
                    secondVertical: .distanceToBottom(bottomAnchor, 0)
                )
            }
        }
    }
    
    // MARK - subview constructions
    
    func demoConstrain(view: UIView, height: CGFloat = 40, width: CGFloat = 100) {
        addSubview(view)
        view.constraints(
            firstHorizontal: .centeredHorizontallyWith(self),
            secondHorizontal: .width(width),
            vertical: .centeredVerticallyTo(self),
            secondVertical: .height(height)
        )
    }
    
    func addSubViewsLikeStackView(_ views: [UIView])  {
        var views = views
        guard let first = views.pullFirst() else { return }
        addConstrainedToTopAndBottom(first)
        first.constraint(from: .distanceToLeading(leadingAnchor, 0))
        var latest = first
        for v in views {
            addConstrainedToTopAndBottom(v)
            v.constraint(from: .distanceToLeading(latest.trailingAnchor, 0))
            v.constraint(from: .proportionalWidthTo(latest, 1))
            latest = v
        }
        latest.constraint(from: .distanceToTrailing(trailingAnchor, 0))
    }
    
    @discardableResult
    func addSubViewsLikeStackView(_ views: [UIView], spacerColor: UIColor, spacerWidth: CGFloat = 1.5) -> CentipedeModel? {
        var views = views
        guard let first = views.pullFirst() else { return nil }
        addConstrainedToTopAndBottom(first)
        first.constraint(from: .distanceToLeading(leadingAnchor, 0))
        var latest = first
        var centipedeModel = CentipedeModel(first: first, containers: [])
        for v in views {
            let spacer = UIView()
            addConstrainedToTopAndBottom(spacer)
            spacer.constraint(from: .width(spacerWidth))
            spacer.backgroundColor = spacerColor
            spacer.constraint(from: .distanceToLeading(latest.trailingAnchor, 0))
            addConstrainedToTopAndBottom(v)
            v.constraint(from: .distanceToLeading(spacer.trailingAnchor, 0))
            v.constraint(from: .proportionalWidthTo(latest, 1))
            latest = v
            centipedeModel.containers.append(SpacerContainer(spacer: spacer, view: v))
        }
        latest.constraint(from: .distanceToTrailing(trailingAnchor, 0))
        return centipedeModel
    }
    
    func addConstrainedToTopAndBottom(_ view: UIView) {
        addSubview(view)
        view.constraint(from: .distanceToTop(topAnchor, 0))
        view.constraint(from: .distanceToBottom(bottomAnchor, 0))
    }
    
    var flattenedSubViews: [UIView] {
        var returnViews: [UIView] = []
        var nextViews: [UIView] = [self]
        while nextViews.hasElements {
            var viewsToAdd: [UIView] = []
            for _ in nextViews {
                let last = nextViews.removeLast()
                returnViews.append(last)
                viewsToAdd.append(contentsOf: last.subviews)
            }
        }
        return returnViews
    }
    
    var andFlattenedSubViews: [UIView] {
        return [self] + flattenedSubViews
    }
    
    // MARK - computed properties
    
    var halfHeight: CGFloat {
        return frame.height / 2
    }
    
    func the(view first: UIView?, isAbove second: UIView?) -> Bool {
        guard let cellArrowPoint = first?.frame.origin,
            let vcHolderPoint = second?.frame.origin,
            let cellArrowPointinView = first?.convert(cellArrowPoint, to: self),
            let vcHolderPointinView = second?.convert(vcHolderPoint, to: self) else { return false }
        var top: CGFloat = 0
        if #available(iOS 11.0, *),
            let safeAreaTopHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            top = safeAreaTopHeight
        }
        return cellArrowPointinView.y < vcHolderPointinView.y - top
    }
    
    var parent: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    // MARK - pin to edges
    
    func pinToEdges(_ subView: UIView, padding: Int) {
        self.pinToEdges(subView, padding: CGFloat(padding))
    }
    
    func pinToEdges(_ subView: UIView, padding: CGFloat) {
        self.pinToEdges(subView, padding: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    func pinToEdges(_ subView: UIView, padding: UIEdgeInsets = .zero) {
        self.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(padding.top)-[view]-\(padding.bottom)-|", options: [], metrics: nil, views: ["view" : subView])
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(padding.left)-[view]-\(padding.right)-|", options: [], metrics: nil, views: ["view": subView])
        self.addConstraints(widthConstraints + heightConstraints)
    }
    
    
    // MARK - clear
    
    func removeAllSubViews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func clearSubViews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    // MARK - animate update.
    
    func updateWithBounceAnimation(with duration: TimeInterval = 0.6, delay: Double = 0.0, usingSpringWithDampening: CGFloat = 0.75, initialSPringVelocity: CGFloat = 1.0) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDampening, initialSpringVelocity: initialSPringVelocity, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }) {_ in
            //self.isScrollViewDisabled = false
        }
    }
}


public extension Array {
    var hasElements: Bool {
        return !isEmpty
    }
}
