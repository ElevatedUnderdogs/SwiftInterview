//
//  UITableView+State.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import UIKit

public protocol ExactlyEqual {
    static func === (lhs: Self, rhs: Self) -> Bool
}


public extension UITableView.BackgroundView {
    
    typealias ViewModel = ImageLabelButtonViewModel
}

extension UITableView.BackgroundView.ViewModel {
    
}

public extension UITableView {
    class BackgroundView: UIView {
        
        // MARK - properties
        
        var buttonAction: Action? {
            get {
                return contentsView.buttonAction
            }
            set(new) {
                contentsView.buttonAction = new
            }
        }
        
        var contentsView = ImageLabelButtonView()
        
        // MARK - style
        
        func updateAkinConstraints() {}
        
        func setupView() {
            addSubview(contentsView)
            
            /// Mark change this to make it sit above the search on iphone 8.
            contentsView.constraint(from: .distanceToTop(self.topAnchor, 120))
            contentsView.constraint(from: .centeredHorizontallyWith(self))
            contentsView.constraint(from: .proportionalWidthTo(self, 0.75))
        }
        
        func setButton(action: @escaping Action) {
            self.contentsView.buttonAction = action
        }
        
        func style(as style: ImageLabelButtonViewModel) {
            contentsView.style = style
        }
        
        // MARK - initializers
        
        convenience init(as style: ImageLabelButtonViewModel) {
            self.init()
            self.style(as: style)
        }
        
        convenience init(model: ViewModel) {
            self.init(as: model)
        }
        
        
        convenience init?(
            tableViewDataSource lists: [Any],
            as style: ImageLabelButtonViewModel,
            isLoading: Bool
            ) {
            if lists.isEmpty && !isLoading {
                self.init(as: style)
            }
            return nil
        }
    }
}


public extension UITableView {
    
    enum State: Equatable, Hashable, ExactlyEqual {
        case loading
        case disconnected
        case hasResults(UITableView.Model)
        case noResults(UITableView.BackgroundView.ViewModel)
        
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .loading:
                hasher.combine("loading")
            case .hasResults(_):
                hasher.combine("hasResults")
            case .noResults(_):
                hasher.combine("noResults")
            case .disconnected:
                hasher.combine("disconnected")
            }
        }
        
        var isLoading: Bool {
            return self == State.loading
        }
        
        var hasResults: Bool {
            if case .hasResults(_) = self {
                return true
            }
            return false
        }
        
        var noResults: Bool {
            if case .noResults(_) = self {
                return true
            }
            return false
        }
        
        var model: UITableView.Model? {
            if case .hasResults(let model) = self {
                return model
            }
            return nil
        }
        
        var dataSourceDelegate: UITableView.DataSourceDelegate? {
            if case .hasResults(let model) = self {
                return model.dateSourceDelegate
            }
            return nil
        }
        
        var prefetch: UITableViewDataSourcePrefetching? {
            if case .hasResults(let model) = self {
                return model.prefetch
            }
            return nil
        }
        
        var backgroundModel: UITableView.BackgroundView.ViewModel? {
            if case .noResults(let model) = self {
                return model
            }
            return nil
        }
        
        
        public static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading): return true
            case (.disconnected, .disconnected): return true
            case ( .hasResults(_), .hasResults(_)): return true
            case ( .noResults(_), .noResults(_)): return true
            default: return false
            }
        }
        
        public static func === (lhs: UITableView.State, rhs: UITableView.State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading): return true
            case (.disconnected, .disconnected): return true
            case ( .hasResults(let resultslhs), .hasResults(let resultsrhs)):
                return resultslhs == resultsrhs
            case ( .noResults(_), .noResults(_)): return true
            default: return false
            }
        }
        
        ///        *Design notes*
        ///        Would it be better to put this in a computed style property?
        ///        pros - you can change a property on this view model and it would reflect in the style.
        ///        - you can access values more readily at the surface instead of digging to see if it has the value, fewer layers. But it would add a layer because enums cannot have stored properties...net the same layers. But an enum keeps the safety because it ensures you don't accidentally use information you should not be using.  For example, you should not be using a datasource when there are no items in it, you should use a background view
        ///
        ///        cons - it would encourage people to use the view model for its state instead of initiating a new one
//        init(
//            isLoading: Bool,
//            isConnectedToTheInternet: Bool,
//            relevantRequirements: [Requirement],
//            requirementsDataSource: RequirementsDataSource,
//            itemsCount: Int,
//            tableViewModel: UITableView.Model,
//            noResultsBackground: UITableView.BackgroundView.ViewModel
//            ) {
//            guard relevantRequirements.isEmpty else {
//                requirementsDataSource.requirements = relevantRequirements
//                let tableViewModel = UITableView.Model(
//                    dateSourceDelegate: requirementsDataSource
//                )
//                self = .hasResults(tableViewModel)
//                return
//            }
//            self.init(
//                isLoading: isLoading,
//                isConnectedToTheInternet: isConnectedToTheInternet,
//                itemsCount: itemsCount,
//                tableViewModel: tableViewModel,
//                noResultsBackground: noResultsBackground
//            )
//        }
        
        init(
            isLoading: Bool,
            isConnectedToTheInternet: Bool,
            itemsCount: Int,
            tableViewModel: UITableView.Model,
            noResultsBackground: UITableView.BackgroundView.ViewModel
            ) {
            if itemsCount == 0 {
                guard isConnectedToTheInternet else {
                    self = .disconnected
                    return
                }
                if isLoading {
                    self = .loading
                } else {
                    self = .noResults(noResultsBackground)
                }
            } else {
                self = .hasResults(tableViewModel)
            }
        }
    }
}
