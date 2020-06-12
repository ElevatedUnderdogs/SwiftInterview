//
//  UITableView+Model.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import UIKit

public extension UITableView {
    
    struct Model: Equatable {
        public static func == (lhs: UITableView.Model, rhs: UITableView.Model) -> Bool {
            switch (lhs.dateSourceDelegate, rhs.dateSourceDelegate) {
            case (.none, .none): do {}
            case (.none, .some(_)): return false
            case (.some(_), .none): return false
            case (.some(let first), .some(let second)):
                if Unmanaged.passUnretained(first).toOpaque() != Unmanaged.passUnretained(second).toOpaque() {
                    return false
                }
            }
            
            switch (lhs.prefetch, rhs.prefetch) {
            case (.none, .none): do {}
            case (.none, .some(_)): return false
            case (.some(_), .none): return false
            case (.some(let first), .some(let second)):
                if Unmanaged.passUnretained(first).toOpaque() != Unmanaged.passUnretained(second).toOpaque() {
                    return false
                }
            }
            return lhs.lastRow == rhs.lastRow
        }
        
        var dateSourceDelegate: UITableView.DataSourceDelegate?
        var prefetch: UITableViewDataSourcePrefetching?
        var lastRow: UITableView.Row?
        
        static var empty: Model {
            return Model(
                dateSourceDelegate: nil,
                prefetch: nil,
                lastRow: nil
            )
        }
        
        init(
            dateSourceDelegate: UITableView.DataSourceDelegate? = nil,
            prefetch: UITableViewDataSourcePrefetching? = nil ,
            lastRow: UITableView.Row? = nil
            ) {
            self.dateSourceDelegate = dateSourceDelegate
            self.prefetch = prefetch
            self.lastRow = lastRow
        }
    }
}

