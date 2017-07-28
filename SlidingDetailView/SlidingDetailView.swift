//
//  SlidingDetailView.swift
//  SlidingDetailView
//
//  Created by Kacper Raczy on 23.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit

public class SlidingDetailView: UIView {
    
    //MARK: Enums
    
    public enum SlidingDetailViewState {
        case normal
        case expanded
        case collapsed
    }

    public enum SlidingDetailViewAnchor {
        case bottom
        case top
        case right
        case left
    }
    
    //MARK: Properties
    
    private var _normalHeight: CGFloat!
    
    private var _expandedHeight: CGFloat?
    
    private var _anchor: SlidingDetailViewAnchor!
    
    private var _currentSDVState: SlidingDetailViewState = .collapsed
    
    private var _animationDuration: Double = 0.3
    
    
    //is overwritten
    private var shouldInvertAnchorConstant: Bool
    
    //layout guides
    
    public var topLayouyGuide: UILayoutSupport? {
        didSet{
            
        }
    }
    
    public var bottomLayoutGuide: UILayoutSupport? {
        didSet{
            
        }
    }
    
    
    //MARK: Initialization
    
    public init(_ anchor: SlidingDetailViewAnchor, withNormalHeight normal: CGFloat, expandedHeight expanded: CGFloat?) {
        
        self._normalHeight = normal
        self._expandedHeight = expanded
        self._anchor = anchor
        
        switch anchor {
        case .top, .left:
            shouldInvertAnchorConstant = true
        case .bottom, .right :
            shouldInvertAnchorConstant = false
        }
        
        super.init(frame: CGRect.zero)
    }
    
    public convenience init(_ anchor: SlidingDetailViewAnchor, withNormalHeight normal: CGFloat) {
        self.init(anchor, withNormalHeight: normal, expandedHeight: nil)
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
    
    private func checkAnchorInvertionStatus(forAnchor anchor: SlidingDetailViewAnchor) -> Bool {
        switch anchor {
        case .top, .left:
            return true
        case .bottom, .right :
            return false
        }
    }
    
    //MARK: Getters and Setters
    
    public var normalHeight: CGFloat {
        get{
            return _normalHeight
        }
        set {
            _normalHeight = newValue
            setCurrentStateConstraints(state: _currentSDVState)
        }
    }
    
    public var expandedHeight: CGFloat? {
        get{
            return _expandedHeight
        }
        set{
            _expandedHeight = newValue
            setCurrentStateConstraints(state: _currentSDVState)
        }
    }
    
    public var currentState: SlidingDetailViewState {
        get {
            return _currentSDVState
        }
        set{
            _currentSDVState = newValue
            setCurrentStateConstraints(state: newValue)
            animateChanges()
        }
    }
    
    public var slideDuration: Double {
        get {
            return _animationDuration
        }
        set{
            _animationDuration = newValue
        }
    }
    
    public var anchor: SlidingDetailViewAnchor {
        get {
            return _anchor
        }
    }
    
    //MARK: Constraints
    
    private var sdv_sizeConstraint:NSLayoutConstraint!
    private var sdv_anchorConstraint:NSLayoutConstraint!
    
    private func configureConstraints(superView: UIView) {
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        sdv_sizeConstraint = createSizeConstraint()
        sdv_anchorConstraint = createAnchorConstraint(superView: superView)
        let supportConstraints = createSupportConstraints(superView: superView)
        
        //TODO: memories this constraints for later operation
        NSLayoutConstraint.activate([sdv_anchorConstraint, sdv_sizeConstraint])
        NSLayoutConstraint.activate(supportConstraints)
        
        _currentSDVState = .collapsed
        
    }
    
    private func createSizeConstraint() -> NSLayoutConstraint {
        var sizeConstraint: NSLayoutConstraint!
        switch anchor {
        case .top,.bottom:
            sizeConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        case .left, .right:
            sizeConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        }
        return sizeConstraint
    }
    
    private func createAnchorConstraint(superView: UIView) -> NSLayoutConstraint {
        var anchorConstraint: NSLayoutConstraint!
        if anchor != .left && anchor != .right {
            var layoutGuide: Any?
            if anchor == .top {
                layoutGuide = topLayouyGuide ?? superView
                anchorConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: layoutGuide!, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            } else if anchor == .bottom {
                layoutGuide = bottomLayoutGuide ?? superView
                anchorConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: layoutGuide!, attribute: .top, multiplier: 1.0, constant: 0.0)
            }
            

        }else {
            let assiociatedAttr = getAssiociatedLayoutAttribute(anchor: anchor)
            anchorConstraint = NSLayoutConstraint(item: self, attribute: assiociatedAttr, relatedBy: .equal, toItem: superView, attribute: assiociatedAttr, multiplier: 1.0, constant: 0.0)
        }
        
        return anchorConstraint
    }
    
    func createSupportConstraints(superView: UIView) -> [NSLayoutConstraint] {
        var supportConstraints: [NSLayoutConstraint] = []
        
        switch anchor {
        case .bottom, .top:
            let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superView, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 0.0)
            supportConstraints.append(contentsOf: [left,right])
        case .left, .right:
            let topAnchorObject: Any? = topLayouyGuide
            let bottomAnchorObject: Any? = bottomLayoutGuide
            
            var top: NSLayoutConstraint!
            var bottom: NSLayoutConstraint!
            if topAnchorObject != nil {
                top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: topAnchorObject, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            }else {
                top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 0.0)
            }
            
            if bottomAnchorObject != nil {
                bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: bottomAnchorObject, attribute: .top, multiplier: 1.0, constant: 0.0)
            }else {
                bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            }
            supportConstraints.append(contentsOf: [top,bottom])
        }
        
        return supportConstraints
    }
    
    private func getAssiociatedLayoutAttribute(anchor: SlidingDetailViewAnchor) -> NSLayoutAttribute {
        switch anchor {
        case .top:
            return NSLayoutAttribute.top
        case .bottom:
            return NSLayoutAttribute.bottom
        case .left:
            return NSLayoutAttribute.left
        case .right:
            return NSLayoutAttribute.right
        }
    }
    
    //MARK: Animation
    
    private func animateChanges() {
        self.isHidden = false
        UIView.animate(withDuration: _animationDuration, delay: 0.0, options: [], animations: { 
            self.superview?.layoutIfNeeded()
        }) { (_) in
            if self._currentSDVState == .collapsed {
                self.isHidden = true
            }
        }
    }
    
    private func setCurrentStateConstraints(state: SlidingDetailViewState) {
        switch state {
        case .normal:
            sdv_sizeConstraint.constant = self._normalHeight
            sdv_anchorConstraint.constant = 0.0
        case .collapsed:
            sdv_sizeConstraint.constant = self._normalHeight
            if shouldInvertAnchorConstant {
                sdv_anchorConstraint.constant = self._normalHeight * (-1)
            }else {
                sdv_anchorConstraint.constant = self._normalHeight
            }
        case .expanded:
            sdv_sizeConstraint.constant = self._expandedHeight ?? self._normalHeight
            sdv_anchorConstraint.constant = 0.0
        }
    }
    
    
    //MARK: TODO
    
    //TODO animationDefaultOptions: springEffect, uiViewAnimateOptions, animationDuration
    //TODO setting view state: simple & advanced method(completionBlock?)
    //TODO gestureRecognizers: panGR, springEffectOnMaximumHeight
    //TODO delegate protocol and methods
    //TODO do not rely on visible vc(get reference to parent vc in init?)!!

}

