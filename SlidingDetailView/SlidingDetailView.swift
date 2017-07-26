//
//  SlidingDetailView.swift
//  SlidingDetailView
//
//  Created by Kacper Raczy on 23.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit

public class SlidingDetailView: UIView {
    
    let normalHeight: CGFloat!
    let expandedHeight: CGFloat!
    
    private var _anchor: SlidingDetailViewAnchor!
    
    private var _currentSDVState: SlidingDetailViewState = .collapsed
    
    let animationDuration: Double = 0.3
    
    
    //TODO slide direction enum
    
    public init(withNormalHeight normal: CGFloat, expandedHeight expanded: CGFloat?) {
        
        self.normalHeight = normal
        self.expandedHeight = expanded ?? normal
//        self._anchor = anchor
        
        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let v = superview else {
            return
        }
        
        configureConstraints(superView: v)
    }
    
    public var currentState: SlidingDetailViewState {
        get {
            return _currentSDVState
        }
        set{
            _currentSDVState = newValue
            switch newValue {
            case .normal:
                sdv_heightConstraint.constant = self.normalHeight
                sdv_bottomConstraint.constant = 0.0
            case .collapsed:
                sdv_heightConstraint.constant = self.normalHeight
                sdv_bottomConstraint.constant = self.normalHeight
            case .expanded:
                sdv_heightConstraint.constant = self.expandedHeight
                sdv_bottomConstraint.constant = 0.0
            }
            animateChanges()
        }
    }
    
    public var anchor: SlidingDetailViewAnchor {
        get {
            return _anchor
        }
    }
    
    public enum SlidingDetailViewState {
        case normal
        case expanded
        case collapsed
    }
    
    //TODO
    public enum SlidingDetailViewAnchor {
        case bottom
        case top
        case right
        case left
    }
    
    private var sdv_heightConstraint:NSLayoutConstraint!
    private var sdv_bottomConstraint:NSLayoutConstraint!
    
    private func configureConstraints(superView: UIView) {
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        sdv_bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        sdv_heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        //TODO: memories this constraints for later operation
        NSLayoutConstraint.activate([sdv_bottomConstraint,leading,trailing,sdv_heightConstraint])
        
        _currentSDVState = .collapsed
    }
    
    private func animateChanges() {
        UIView.animate(withDuration: animationDuration) { 
            self.superview?.layoutIfNeeded()
        }
    }
    
    //TODO animationDefaultOptions: springEffect, uiViewAnimateOptions, animationDuration
    //     setting view state: simple & advanced method(completionBlock?)
    //     gestureRecognizers: panGR, springEffectOnMaximumHeight
    

}
