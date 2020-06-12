//
//  UITableView.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation
import UIKit


public extension UITableView {
    
    typealias DataSourceDelegate = UITableViewDataSource & UITableViewDelegate
    
    typealias Row = Int
    
    // MARK - helpers
    
    func set(_ delegateAndDataSource: DataSourceDelegate?) {
        delegate = delegateAndDataSource
        dataSource = delegateAndDataSource
    }
    
    func register(_ cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.reuseID)
    }
    
    func register(_ cells: UITableViewCell.Type...) {
        for cell in cells {
            register(cell, forCellReuseIdentifier: cell.reuseID)
        }
    }
    
    var dataSourceDelegate: DataSourceDelegate? {
        get {
            return dataSource === delegate ? dataSource as? DataSourceDelegate : nil
        }
        set {
            self.dataSource = newValue
            self.delegate = newValue
        }
    }
    
    // MARK - scroll methods
    
    func scrollUpIfNeeded() {
        let rectOfCell = rectForRow(at: .first),
        rectOfCellInSuper = convert(rectOfCell, to: superview)
        if rectOfCellInSuper.minY < 0 || !isCellVisible(section: 0, row: 0) {
            safelyScrollToRow(at: .first, at: .top, animated: true)
        }
    }
    
    func safelyScrollToRow(
        at indexPath: IndexPath,
        at scrollPosition: UITableView.ScrollPosition = .top,
        animated: Bool = false
        ) {
        DispatchQueue.main.async {
            self.pointerSafeScrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        }
    }
    
    func pointerSafeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard has(indexPath) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    enum VerticalSide {
        case top, bottom
    }
    
    func scroll(to: VerticalSide, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    func has(_ indexPath: IndexPath) -> Bool {
        let num1 = numberOfSections > indexPath.section
        let num2 = numberOfRows(inSection: indexPath.section) > indexPath.row
        return num1 && num2
    }
    
    
    func safelyScrollToRow(at singleSectionRow: UITableView.Row?) {
        guard let row = singleSectionRow else { return }
        safelyScrollToRow(at: IndexPath(row: row, section: 0))
    }
    
    // MARK - computed properties
    
    ///This is used only for a cell created with a storyboard.  Do not use this if you created the cell programmatically.
    func cell<T: UITableViewCell>() -> T {
        if let cell = dequeueReusableCell(withIdentifier: T.reuseID) as? T {
            cell.selectionStyle = .none
            return cell
        } else {
            fatalError("Make sure the reuse id matches the cell being used in storyboard, and that its on the table view being used And that its registered")
        }
    }
    
    
    ///Must be accessed from main thread.
    var topVisibibleIndexPath: IndexPath? {
        guard let visibleRows = indexPathsForVisibleRows,
            !visibleRows.isEmpty else { return nil }
        return visibleRows[0]
    }
    
    func hasRow(at indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections
            && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    
    func isCellVisible(section:Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains {$0.section == section && $0.row == row }
    }
    
    func rect(of indexPath: IndexPath, relativeTo view: UIView) -> CGRect {
        return convert( rectForRow(at: indexPath), to: view)
    }
    
    // MARK - reload methods
    
    func safelyReload(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        DispatchQueue.main.async {
            self.reloadRows(at: indexPaths, with: animation)
        }
    }
    
    //Crashing
    //    /// Cannot use indexPathsForVisibleRows as a default parameter.
    //    func safelyReloadVisibleRows(with animation: RowAnimation) {
    //        guard let indexPaths: [IndexPath] = self.indexPathsForVisibleRows else { return }
    //        DispatchQueue.main.async {
    //            self.reloadRows(at: indexPaths, with: animation)
    //        }
    //    }
    
    
    func safelyReload(_ rows: [IndexPath], with animation: RowAnimation) {
        DispatchQueue.main.async {
            self.reloadRows(at: rows, with: animation)
        }
    }
    
    func safelyReload() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
