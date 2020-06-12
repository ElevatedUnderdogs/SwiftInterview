//
//  CleanTable.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import UIKit

public typealias SimpleTable = CleanTable


public class CleanTable: UITableView {
    
    // MARK - state enum
    
    enum CleanState {
        case empty, hasResults, loading
    }
    
    func updateAkinConstraints() {}
    
    // MARK - properties
    
    var emptyResultView = UIView()
    var activityIndicatorStyle = UIActivityIndicatorView.Style.gray
    var spinnerColor =  UIColor.darkGray
    var emptyResultsImageView = UIImageView()
    var emptyResultsText = UILabel()
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    // MARK - init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK - style
    
    func setValues(spinnerColor: UIColor, style: UIActivityIndicatorView.Style, emptyImage: UIImage, emptyText: String) {
        self.spinnerColor = spinnerColor
        self.activityIndicatorStyle = style
        self.emptyResultsImageView.image = emptyImage
        self.emptyResultsText.text = emptyText
    }
    
    func setupView() {
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        separatorStyle = .none
        activityIndicator.color = spinnerColor
        addSubview(emptyResultView)
        loadingView.addSubview(activityIndicator)
        addSubview(loadingView)
        emptyResultView.constraints(
            horizontals: .centeredHorizontallyWith(self),
            verticals: .centeredVerticallyTo(self),
            activated: true
        )
        emptyResultView.backgroundColor = .clear
        emptyResultView.addSubview(emptyResultsImageView)
        emptyResultView.addSubview(emptyResultsText)
        emptyResultsImageView.constraints(
            firstHorizontal: .centeredHorizontallyWith(self),
            secondHorizontal: .proportionalWidthTo(self, 1),
            vertical: .distanceToTop(topAnchor, 0),
            secondVertical: .distanceToBottom(emptyResultsText.topAnchor, 10)
        )
        emptyResultsText.constraint(from: .centeredVerticallyTo(self))
        emptyResultsText.constraint(from: .proportionalWidthTo(self, 1))
        emptyResultsText.constraint(from: .distanceToBottom(bottomAnchor, 0))
        
        emptyResultsImageView.contentMode = .scaleAspectFit
        
        activityIndicator.constraints(
            horizontals: .centeredHorizontallyWith(loadingView),
            verticals: .centeredVerticallyTo(loadingView),
            activated: true
        )
        loadingView.pinToEdges(activityIndicator)
        loadingView.constraints(
            firstHorizontal: .centeredHorizontallyWith(self),
            secondHorizontal: .width(40),
            vertical: .centeredVerticallyTo(self),
            secondVertical: .height(40)
        )
        set(state: .loading)
    }
    
    // MARK - handle state
    
    func setState(from array: Array<Any>) {
        set(state: array.isEmpty ? .empty : .hasResults)
    }
    
    func set(state: CleanState) {
        spinner(show: state == .loading)
        results(empty: state == .empty)
    }
    
    private func results(empty: Bool) {
        DispatchQueue.main.async {
            self.emptyResultsImageView.isHidden = !empty
            self.emptyResultsText.isHidden = !empty
        }
    }
    
    private func spinner(show: Bool) {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = !show
            self.activityIndicator.animate(show)
            self.activityIndicator.isHidden = !show
        }
    }
}
