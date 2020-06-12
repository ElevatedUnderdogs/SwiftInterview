//
//  SearchBar.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import UIKit

/*
 
 SEARCH CONTAINER
 _____________________________________________________________________________________________________
 |     _________________________________________________________________________________________     |
 |    / SEARCH BAR                                                                              \    |
 |   /      _________        ______________________________________________________     _________\   |
 |  |      |magnify |       | placeholder button                                 |     |xButton | |  |
 |  |      |button  |       |                                                    |     |        | |  |
 |   \     |________|       |_search text field__________________________________|     |________|/   |
 |    \                                                                                         /    |
 |     \_______________________________________________________________________________________/     |
 |___________________________________________________________________________________________________|
 
 */

public typealias TextFieldAction = (UITextField) -> Void

public class SearchBar: UIView {
    
    // MARK - UI properties
    
    var searchBarSubContainer = UIView()
    var magnifyingGlass = UIButton()
    var placeHolder = UIButton()
    var xButton = UIButton()
    var searchField = UITextField()
    
    // MARK - actions
    
    var userStartedSearchingAction: Action?
    var userEditedSearchAction: TextFieldAction?
    var closePressedAction: Action?
    
    public func set(
        userStartedSearchingAction: Action? = nil,
        userEditedSearchAction: TextFieldAction? = nil,
        closeTappedAction: Action? = nil
        ) {
        self.userStartedSearchingAction = userStartedSearchingAction
        self.userEditedSearchAction = userEditedSearchAction
        self.closePressedAction = closeTappedAction
    }
    
    @objc func searchXPressed() {
        parent?.view.endEditing(true)
        slide(.up)
        closePressedAction?()
    }
    
    @objc func userStartedSearching() {
        placeHolder.isHidden = true
        hidePlaceHolderIfEmpty()
        userStartedSearchingAction?()
    }
    
    @objc func userEditedSearch(_ textField: UITextField) {
        hidePlaceHolderIfEmpty()
        userEditedSearchAction?(textField)
    }
    
    // MARK - changeable constraints
    
    var responseTVToBottomSearchContainer: NSLayoutConstraint?
    var responseTVTopToSuperViewTop: NSLayoutConstraint?
    var topOfSearchContainer: NSLayoutConstraint?
    var searchContainerToSuperview: NSLayoutConstraint?
    
    // MARk - style
    
    var cursorColor: UIColor? = .white {
        didSet {
            searchField.tintColor = cursorColor
            searchField.tintColorDidChange()
            searchField.textColor = cursorColor
        }
    }
    
    func setColors(
        backgroundColor: UIColor = .clear,
        searchBarBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.34),
        magnifyierColor: UIColor = .white,
        xButtonColor: UIColor = .white,
        placeHolderColor: UIColor = .white,
        borderColor: UIColor = .clear,
        cursorColor: UIColor = .black
        ) {
        self.backgroundColor = backgroundColor
        self.searchBarSubContainer.backgroundColor = searchBarBackgroundColor
        self.magnifyingGlass.tintColor = magnifyierColor
        self.xButton.tintColor = xButtonColor
        self.placeHolder.setTitleColor(placeHolderColor, for: .normal)
        self.searchBarSubContainer.layer.borderColor = borderColor.cgColor
        self.cursorColor = cursorColor
    }
    
    func setAccessibility() {
        searchBarSubContainer.accessibilityIdentifier = "search bar sub container"
        magnifyingGlass.accessibilityIdentifier = "magnifying glass button"
        placeHolder.accessibilityIdentifier = "search bar placeholder"
        xButton.accessibilityIdentifier = "close search button"
        searchField.accessibilityIdentifier = "search field"
    }
    
    
    private func setColors() {
        searchField.tintColor = .black
    }
    
    func reset() {
        placeHolder.isHidden = false
        searchField.text = nil
    }
    
    func updateAkinConstraints() {
        addSubview(searchBarSubContainer)
        searchBarSubContainer.constraints(
            firstHorizontal: .centeredHorizontallyWith(self),
            secondHorizontal: .distanceToTrailing(trailingAnchor, 41),
            vertical: .centeredVerticallyTo(self),
            secondVertical: .height(40)
        )
        searchBarSubContainer.addSubview(magnifyingGlass)
        magnifyingGlass.constraints(
            firstHorizontal: .distanceToLeading(searchBarSubContainer.leadingAnchor, 13),
            secondHorizontal: .width(18),
            vertical: .centeredVerticallyTo(searchBarSubContainer),
            secondVertical: .height(18)
        )
        searchBarSubContainer.addSubview(xButton)
        xButton.constraints(
            firstHorizontal: .distanceToTrailing(searchBarSubContainer.trailingAnchor, 14),
            secondHorizontal: .width(15),
            vertical: .centeredVerticallyTo(searchBarSubContainer),
            secondVertical: .height(15)
        )
        searchBarSubContainer.addSubview(placeHolder)
        placeHolder.constraints(
            firstHorizontal: .distanceToLeading(magnifyingGlass.trailingAnchor, 5),
            secondHorizontal: .distanceToTrailing(xButton.leadingAnchor, 5),
            vertical: .centeredVerticallyTo(searchBarSubContainer),
            secondVertical: .distanceToBottom(searchBarSubContainer.bottomAnchor, 5)
        )
        searchBarSubContainer.addSubview(searchField)
        searchField.constraints(
            firstHorizontal: .distanceToLeading(placeHolder.leadingAnchor, 0),
            secondHorizontal: .distanceToTrailing(placeHolder.trailingAnchor, 0),
            vertical: .distanceToBottom(placeHolder.bottomAnchor, 0),
            secondVertical: .distanceToTop(placeHolder.topAnchor, 0)
        )
        constraint(from: .height(80)).isActive = true
    }
    
    func hidePlaceHolderIfEmpty() {
        if let text = searchField.text, text.count > 0 {
            placeHolder.isHidden = true
        } else {
            placeHolder.isHidden = false
        }
    }
    
    // MARK - computed properties
    
    let recommendedHeight: CGFloat = 80
    let searchTitle = "Search Questions..."
    
    // MARK - parent property
    
    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        return searchField.becomeFirstResponder()
    }
    
    // MARK - configuration
    
    
    func addToTopOf(_ view: UIView, andConnectTo table: UITableView? = nil, connectedViewTopConstraint: NSLayoutConstraint? = nil) {
        view.addSubview(self)
        if let table = table {
            responseTVToBottomSearchContainer = constraint(from: .distanceToBottom(table.topAnchor, 0), isActive: false)
            responseTVToBottomSearchContainer?.priority = UILayoutPriority(rawValue: 999)
            responseTVToBottomSearchContainer?.isActive = true
        }
        responseTVTopToSuperViewTop = connectedViewTopConstraint
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            topOfSearchContainer = constraint(from: .distanceToTop(guide.topAnchor, 0), isActive: false)
        } else {
            topOfSearchContainer = constraint(from: .distanceToTop(view.topAnchor, 8), isActive: false)
        }
        topOfSearchContainer?.priority = UILayoutPriority(rawValue: 999)
        topOfSearchContainer?.isActive = true
        searchContainerToSuperview = constraint(from: .distanceToBottom(view.topAnchor, 100), isActive: false)
        searchContainerToSuperview?.isActive = true
        constraint(from: .distanceToLeading(view.leadingAnchor, 0)).isActive = true
        constraint(from: .distanceToTrailing(view.trailingAnchor, 0)).isActive = true
    }
    
    // MARK - animate
    
    func slide(_ direction: VerticalDirection, completion: Action? = nil) {
        responseTVTopToSuperViewTop?.isActive = direction == .up
        responseTVToBottomSearchContainer?.isActive = direction == .down
        let parentView = parent?.view
        self.searchContainerToSuperview?.isActive = direction == .up
        self.topOfSearchContainer?.isActive = direction == .down
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
            parentView?.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.searchBarSubContainer.makeCircularClips()
            })
            completion?()
        })
    }
}


// local
public extension SearchBar {
    // part local part not.
    func setupView() {
        
        setImages()
        setAccessibility()
        
        searchBarSubContainer.layer.borderWidth = 1
        searchBarSubContainer.layer.borderColor = UIColor(red:0.44, green:0.44, blue:0.44, alpha:1.0).cgColor
        magnifyingGlass.set(color: .gray)
        
        placeHolder.setTitle(searchTitle, for: .normal)
        placeHolder.contentHorizontalAlignment = .left
        placeHolder.setTitleColor(.gray, for: .normal)
        placeHolder.titleLabel?.font = UIFont(name: "Avalon", size: 18.0)
        
        searchField.addTarget(self, action: #selector(userStartedSearching), for: .editingDidBegin)
        searchField.addTarget(self, action: #selector(userEditedSearch(_:)), for: .editingChanged)
        xButton.addTarget(self, action: #selector(searchXPressed), for: .touchUpInside)
        
        searchField.increaseFontSize()
    }
    
    private func setImages() {
        magnifyingGlass.setImage(UIImage(named: "searchImg"), for: .normal)
        xButton.setImage(UIImage(named: "lightXNoBorder"), for: .normal)
    }
}
