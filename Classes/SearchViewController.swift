//
//  SearchViewController.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import UIKit

public class SearchVC: UIViewController {
    
    // MARK - properties
    
    var searchBar = SearchBar()
    var table = UITableView()
    
    var shouldStartSearchingUponDisplay: Bool {
        return true
    }
    
    // MARK - lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        constrainViews()
        searchBar.cursorColor = .black
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        appear(true) { self.searchBar.slide(.down) }
        super.viewDidAppear(animated)
        if shouldStartSearchingUponDisplay { searchBar.becomeFirstResponder() }
    }
    
    // MARK - constrain view
    
    func constrainViews() {
        view.addSubview(table)
        let tableConstraints = table.pinToEdges(of: view)
        tableConstraints.activate(true)
        searchBar.addToTopOf(view, andConnectTo: table, connectedViewTopConstraint: tableConstraints.top)
    }
    
    // MARK - dissmiss
    
    
    func dismissSearchVC() {
        searchBar.slide(.up)
        appear(false) {
            self.navigationController?.safelyPopViewController(animated: false)
        }
    }
    
    override public func dismiss(animated flag: Bool, completion: Action? = nil) {
        UIView.animate(withDuration: 0.05, animations: {
            self.view.alpha = 0
            self.searchBar.slide(.down)
        }) { success in
            self.navigationController?.safelyPopViewController(animated: false)
        }
    }
    
    // MARK - appear
    
    func appear(_ shouldAppear: Bool, completion: Action? = nil ) {
        UIView.animate(withDuration: 0.05, animations: {
            self.view.alpha = shouldAppear.float
        }, completion: {success in
            completion?()
        })
    }
}
