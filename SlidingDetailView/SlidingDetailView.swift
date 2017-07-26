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
    
    private var _anchor: SlidingDetailViewAnchor! {
        didSet{
            switch _anchor! {
            case .top, .left:
                shouldInvertAnchorConstant = true
            case .bottom, .right :
                shouldInvertAnchorConstant = false
            }
        }
    }
    
    private var shouldInvertAnchorConstant: Bool = false
    
    private var _currentSDVState: SlidingDetailViewState = .collapsed
    
    let animationDuration: Double = 0.3
    
    
    //TODO slide direction enum
    
    public init(_ anchor: SlidingDetailViewAnchor ,withNormalHeight normal: CGFloat, expandedHeight expanded: CGFloat?) {
        
        self.normalHeight = normal
        self.expandedHeight = expanded ?? normal
        self._anchor = anchor
        
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
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
                sdv_sizeConstraint.constant = self.normalHeight
                sdv_anchorConstraint.constant = 0.0
            case .collapsed:
                sdv_sizeConstraint.constant = self.normalHeight
                sdv_anchorConstraint.constant = self.normalHeight * (shouldInvertAnchorConstant ? -1 : 1)
            case .expanded:
                sdv_sizeConstraint.constant = self.expandedHeight
                sdv_anchorConstraint.constant = 0.0
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
                layoutGuide = getLayoutGuide(.top) ?? superView
                anchorConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: layoutGuide!, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            } else if anchor == .bottom {
                layoutGuide = getLayoutGuide(.bottom) ?? superView
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
            let topAnchorObject: Any? = getLayoutGuide(.top)
            let bottomAnchorObject: Any? = getLayoutGuide(.bottom)
            
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
    
    
    func getLayoutGuide(_ anchor: SlidingDetailViewAnchor) -> UILayoutSupport? {
        var layoutGuide: UILayoutSupport?
        if let currentVC = UIApplication.shared.windows.first?.visibleViewController {
            if anchor == .top{
                layoutGuide = currentVC.topLayoutGuide
            }else if anchor == .bottom{
                layoutGuide = currentVC.bottomLayoutGuide
            }
        }
        
        return layoutGuide
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
    
    
    private func animateChanges() {
        UIView.animate(withDuration: animationDuration) { 
            self.superview?.layoutIfNeeded()
        }
    }
    
    //TODO animationDefaultOptions: springEffect, uiViewAnimateOptions, animationDuration
    //     setting view state: simple & advanced method(completionBlock?)
    //     gestureRecognizers: panGR, springEffectOnMaximumHeight
    //TODO do not rely on visible vc(get reference to parent vc in init?)

}

