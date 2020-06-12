//
//  UIView+Constraint.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import UIKit

public struct ViewWithLeftMargin {
    var leftMargin: CGFloat
    var view: UIView
    var width: CGFloat
    var height: CGFloat? = nil
}

public struct ViewWithRightMargin {
    var rightMargin: CGFloat
    var view: UIView
    var width: CGFloat
    var height: CGFloat? = nil
}


public enum Direction {
    case horizontal(HorizontalDirection)
    case vertical(VerticalDirection)
}

public enum VerticalDirection {
    case down, up
}

public enum HorizontalDirection: String {
    case left, right
    
    var int: Int {
        switch self {
        case .left: return -1
        case .right: return 1
        }
    }
}




public protocol ConstraintDescriptor {}

public extension UIView {
    
    // MARK - enums
    
    enum Orientation {
        case horizontal, vertical
    }
    
    enum Centering {
        case centered, latchToTopMargin
    }
    
    enum LayoutDescriptor {
        case horizontal(HorizontalDescriptor)
        case vertical(VerticalDescriptor)
    }
    
    enum Flexibility {
        case flexible, notFlexible
    }
    
    enum HorizontalDescriptor: ConstraintDescriptor  {
        case centeredHorizontallyWith(UIView)
        case distanceToLeading(NSLayoutAnchor<NSLayoutXAxisAnchor>, CGFloat)
        case distanceToTrailing(NSLayoutAnchor<NSLayoutXAxisAnchor>, CGFloat)
        case proportionalWidthTo(UIView, CGFloat)
        case width(CGFloat)
        
        var description: String {
            switch self {
            case .distanceToLeading(let anchor, let distance):
                return ".distanceToLeft, anchor: \(anchor), distance: \(distance)"
            case .centeredHorizontallyWith(let view):
                return ".centeredWith, view: \(view)"
            case .width(let width):
                return ".width: \(width)"
            case .distanceToTrailing(let anchor, let distance):
                return ".distanceToRight, anchor: \(anchor), distance: \(distance)"
            case .proportionalWidthTo(let view, let multiplier):
                return "proportionalWidthTo: \(view), \(multiplier)"
            }
        }
    }
    
    enum VerticalDescriptor: ConstraintDescriptor {
        case centeredVerticallyTo(UIView)
        case distanceToBottom(NSLayoutAnchor<NSLayoutYAxisAnchor>, CGFloat)
        case distanceToTop(NSLayoutAnchor<NSLayoutYAxisAnchor>, CGFloat)
        case height(CGFloat)
        case proportionalHeightTo(UIView, CGFloat)
        
        
        var description: String {
            switch self {
            case .height(let height):
                return ".height: \(height)"
            case .distanceToTop(let anchor, let distance):
                return ".distanceToTop, anchor: \(anchor), distance: \(distance)"
            case .distanceToBottom(let anchor, let distance):
                return ".distanceToBottom, anchor: \(anchor), distance: \(distance)"
            case .centeredVerticallyTo(let view):
                return ".centeredTo, view: \(view)"
            case .proportionalHeightTo(let view, let multiplier):
                return "proportionalHeightTo(\(view), \(multiplier)"
            }
        }
        
    }
    
    // MARK - add subviews
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    // MARK - add subview with constrained order
    
    func latch(_ view: UIView, to direction: Direction) {
        addSubview(view)
        switch direction {
        case .vertical(let vertical):
            switch vertical {
            case .up:
                constraints(
                    firstHorizontal: .distanceToLeading(leadingAnchor, 0),
                    secondHorizontal: .distanceToTrailing(trailingAnchor, 0),
                    vertical: .distanceToTop(topAnchor, 0)
                )
            case .down:
                constraints(
                    firstHorizontal: .distanceToLeading(leadingAnchor, 0),
                    secondHorizontal: .distanceToTrailing(trailingAnchor, 0),
                    vertical: .distanceToBottom(topAnchor, 0)
                )
            }
        case .horizontal(let horizontal):
            switch horizontal {
            case .left:
                constraints(
                    firstHorizontal: .distanceToLeading(leadingAnchor, 0),
                    vertical: .distanceToTop(topAnchor, 0),
                    secondVertical: .distanceToBottom(bottomAnchor, 0)
                )
            case .right:
                constraints(
                    firstHorizontal: .distanceToTrailing(leadingAnchor, 0),
                    vertical: .distanceToTop(topAnchor, 0),
                    secondVertical: .distanceToBottom(bottomAnchor, 0)
                )
            }
        }
    }
    
    // MARK - assertion
    
    func assertSuppliedViewIsNotaSubView(view: UIView) {
        if subviews.contains(view) {
            assert(false, "Constraints work more reliably if you constrain up.  ie: it is better to do: 'subView.constraints(horizontal: .distanceToLeading(container.leading...' vs 'container.constraints(horizontal: .distanceToLeading(subView.leading...'\(#line) \(#file)"
                )
        }
    }
    
    // MARK - generate constraints
    
    @discardableResult
    func pinToEdges(of view: UIView, margin: CGFloat = 0) -> Constraints {
        let top = constraint(from: .distanceToTop(view.topAnchor, margin))
        let bottom = constraint(from: .distanceToBottom(view.bottomAnchor, margin))
        let left = constraint(from: .distanceToLeading(view.leadingAnchor, margin))
        let right = constraint(from: .distanceToTrailing(view.trailingAnchor, margin))
        return Constraints(top: top, bottom: bottom, left: left, right: right)
    }
    
    
    @discardableResult
    func constraints(_ descriptors: LayoutDescriptor...) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for descriptor in descriptors {
            switch descriptor {
            case .horizontal(let horizontal):
                constraints.append(constraint(from: horizontal))
            case .vertical(let vertical):
                constraints.append(constraint(from: vertical))
            }
        }
        return constraints
    }
    
    
    @discardableResult
    func constraints(
        firstHorizontal: HorizontalDescriptor? = nil,
        secondHorizontal: HorizontalDescriptor? = nil,
        vertical: VerticalDescriptor? = nil,
        secondVertical: VerticalDescriptor? = nil,
        activated shouldActivate: Bool = true
        ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        let horizontals: [HorizontalDescriptor] = [firstHorizontal, secondHorizontal].compactMap { $0 }
        constraints +=  horizontals.compactMap {constraint(from: $0)}
        let verticals: [VerticalDescriptor] = [vertical, secondVertical].compactMap  { $0 }
        constraints += verticals.compactMap {constraint(from: $0)}
        if shouldActivate {NSLayoutConstraint.activate(constraints)}
        return constraints
    }
    
    @discardableResult
    func constraints(
        horizontals: HorizontalDescriptor...,
        verticals: VerticalDescriptor,
        activated shouldActivate: Bool = true
        ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = []
        // constraints += [horizontal, secondHorizontal].compactMap {constraint(from: $0)}
        // constraints += [vertical, secondVertical].compactMap {constraint(from: $0)}
        if shouldActivate {NSLayoutConstraint.activate(constraints)}
        return constraints
    }
    
    func constraints(from constraintsDescriptors: ConstraintDescriptor...) {
        for descriptor in constraintsDescriptors {
            if let horizontal = descriptor as? HorizontalDescriptor {
                let newConstraint = constraint(from: horizontal)
                NSLayoutConstraint.activate([newConstraint])
            }
            if let vertical = descriptor as? VerticalDescriptor {
                let newConstraint = constraint(from: vertical)
                NSLayoutConstraint.activate([newConstraint])
            }
        }
    }
    
    @discardableResult
    func constraint(from: HorizontalDescriptor, isActive: Bool = true) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        var constraint: NSLayoutConstraint
        switch from {
        case .width(let width):
            constraint =  widthAnchor.constraint(equalToConstant: width)
        case let .distanceToLeading(anchor, distance):
            constraint = leadingAnchor.constraint(equalTo: anchor, constant: distance)
        case let .distanceToTrailing(anchor, distance):
            constraint = trailingAnchor.constraint(equalTo: anchor, constant: distance * -1)
        case .centeredHorizontallyWith(let view):
            constraint = centerXAnchor.constraint(equalTo: view.centerXAnchor)
            assertSuppliedViewIsNotaSubView(view: view)
        case .proportionalWidthTo(let view, let multiplier):
            constraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier)
            assertSuppliedViewIsNotaSubView(view: view)
        }
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    func constraint(from: VerticalDescriptor, isActive: Bool = true) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        var constraint: NSLayoutConstraint
        switch from {
        case .height(let height):
            constraint = heightAnchor.constraint(equalToConstant: height)
        case let .distanceToTop(anchor, distance):
            constraint = topAnchor.constraint(equalTo: anchor, constant: distance)
        case let .distanceToBottom(anchor, distance):
            constraint = bottomAnchor.constraint(equalTo: anchor, constant: distance * -1 )
        case .centeredVerticallyTo(let view):
            constraint =  centerYAnchor.constraint(equalTo: view.centerYAnchor)
        case .proportionalHeightTo(let view, let multiplier):
            constraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier)
        }
        constraint.isActive = isActive
        return constraint
    }
}


public struct Constraints {
    var top: NSLayoutConstraint
    var bottom: NSLayoutConstraint
    var left: NSLayoutConstraint
    var right: NSLayoutConstraint
    
    func activate(_ activate: Bool) {
        [top, bottom, left, right].forEach { $0.isActive = activate }
    }
    
    init(top: NSLayoutConstraint, bottom: NSLayoutConstraint, left: NSLayoutConstraint, right: NSLayoutConstraint) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
    }
}
