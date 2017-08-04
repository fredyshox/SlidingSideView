//
//  SlidingSideView.swift
//  SlidingSideView
//
//  Created by Kacper Raczy on 23.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit

//MARK: Enums

/**
 Represents the slide state values of the `SlidingSideView`.
 
 Possible values: `.collapsed`, `.normal`, `.expanded`.
 */
public enum SlidingSideViewState {
    case normal
    case expanded
    case collapsed
}

/**
 The anchor of the `SlidingSideView` which corresponds to the edge of the container
 (or screen if set as `UIViewController`'s view subview).
 
 The anchor decides of the position of the view and direction of the slide effect.
 
 Possible values: `.top`, `.bottom`, `.right`, `.left`.
 */

public enum SlidingSideViewAnchor {
    case bottom
    case top
    case right
    case left
}

/**
 The `SlidingSideView` is main class in the framework. This `UIVIew` subclass 
 controls the presentation of your content.
 
 The `SlidingSideView` uses constraints with superview to position itseft behind 
 chosen edge(anchor) and animates sliding by managing them. The sliding can be controlled
 programmaticaly by setting sliding state(`currentState`) which causes view to change 
 height and slide out.

 
 It can be treated as a regular UIView subclass, and be embedded in regular UIView 
 to achieve similar effects in different contexts.
 
 You provide your own content to it by adding subviews (ex. child `UIViewController` views).
 */

public class SlidingSideView: UIView {
    
    //MARK: Properties
    
    private var _normalHeight: CGFloat!
    
    private var _expandedHeight: CGFloat?
    
    private var _anchor: SlidingSideViewAnchor!
    
    private var _currentSDVState: SlidingSideViewState = .collapsed
    
    private var _animationDuration: Double = 0.3

    private var _delegate: SlidingSideViewDelegate?
    
    private var shouldInvertAnchorConstant: Bool
    
    // Layout guides
    
    /**
     Set this property to your `UIViewController`'s `topLayoutGuide` if you want SlidingSideView layout to be relative to it.
     
     It's very helpful when using `UINavigationController` or status bar.
     
        - Precondition: topLayoutGuide must be set before adding view as a subview.
     */
    
    public var topLayouyGuide: UILayoutSupport? {
        didSet{
            if superview != nil {
                configureConstraints(superView: superview!)
            }
        }
    }
    
    /**
     Set this property to your `UIViewController`'s `bottomLayoutGuide` if you want SlidingSideView layout to be relative to it.
     
     It's very helpful when using `UITabBarController`.
     
     - Precondition: bottomLayoutGuide must be set before adding view as a subview.
     */
    
    public var bottomLayoutGuide: UILayoutSupport? {
        didSet{
            if superview != nil {
                configureConstraints(superView: superview!)
            }
        }
    }
    
    //MARK: Initialization
    
    /**
     Initializes new instance of `SlidingSideView` with given anchor and height for `.normal` state.
     
     When using this method, created instance has no height for `.expanded` state(It's nil). 
     It will behave the same as for `.normal` when set to state `.expanded`.
     
        - parameter anchor: The anchor of created view, which corresponds to the edge of container
                            that SlidingSideView will slide out from.
        - parameter normal: The height for state `.normal`.
     
        - returns: An initialized `SlidingDetailView` object.
     */
    
    public convenience init(_ anchor: SlidingSideViewAnchor, withNormalHeight normal: CGFloat) {
        self.init(anchor, withNormalHeight: normal, expandedHeight: nil)
    }
    
    /**
     Initializes new instance of `SlidingSideView` with given anchor, height for `.normal` state
     and height for `.expanded` state.
     
     - parameter anchor: The anchor of created view, which corresponds to the edge of container 
                         that SlidingSideView will slide out from.
     - parameter normal: The height for state `.normal`.
     - parameter expanded: The optional height fot state `.expanded`.
     
     - returns: An initialized `SlidingDetailView` object.
     */
    
    public init(_ anchor: SlidingSideViewAnchor, withNormalHeight normal: CGFloat, expandedHeight expanded: CGFloat?) {
        
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
    
    /**
     - Attention: This initializer hasn't been implemented yet. Will throw fatal error.
     */
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Tells the view that its superview changed. 
     
     When given superview, sliding side view will configure specific constraints 
     with parent view depending on `anchor` and heights.
     */
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let v = superview else {
            return
        }
        
        configureConstraints(superView: v)
    }
    
    //MARK: Getters and Setters
    
    
    /**
     The view height for slide state `.normal`.
     */
    
    public var normalHeight: CGFloat {
        get{
            return _normalHeight
        }
        set {
            _normalHeight = newValue
            setCurrentStateConstraints(state: _currentSDVState)
        }
    }
    
    /**
     The view height for slide state `.expanded`.
     
     It's nil by default, and then view is using `normalHeight` fot state `.expanded`.
     */
    
    public var expandedHeight: CGFloat? {
        get{
            return _expandedHeight
        }
        set{
            _expandedHeight = newValue
            setCurrentStateConstraints(state: _currentSDVState)
        }
    }
    
    /**
     The current slide state of the sliding side view. 
     
     When set, the view will adjust the visibility and height for:
     not visible for `.collapsed`, visible with `normalHeight` for `.normal`, visible with `expandedHeight` 
     for `.expanded(or the same as normal if expandedHeight is nil). 
     
     The change will be animated with sliding out effect.
     */
    
    public var currentState: SlidingSideViewState {
        get {
            return _currentSDVState
        }
        set{
            _currentSDVState = newValue
            setCurrentStateConstraints(state: newValue)
            animateChanges()
        }
    }
    
    /**
     The anchor of the SlidingSideView which corresponds to the edge of the container
     (or screen if set as `UIViewController`'s view subview).
     
     If you want SlidingSideView to be layout with respect to `UINavigationBar` or 
     `UITabBar` etc. see `topLayoutGuide` and `bottomLayoutGuide` properties.
     */
    
    public var anchor: SlidingSideViewAnchor {
        get {
            return _anchor
        }
    }
    
    /**
     The object that acts as a delegate of the sliding side view.
     
     The delegate must adopt `SlidingSideViewDelegate` protocol.
     */
    
    public var delegate: SlidingSideViewDelegate? {
        get{
            return _delegate
        }
        set{
            _delegate = newValue
        }
    }
    
    // Animation options
    
    /**
     The duration of slide animation in seconds. Set this to customize slide animation.
     */
    
    public var slideDuration: Double {
        get {
            return _animationDuration
        }
        set{
            _animationDuration = newValue
        }
    }
    
    //MARK: Constraints
    
    private var sdv_sizeConstraint:NSLayoutConstraint!
    private var sdv_anchorConstraint:NSLayoutConstraint!
    private var sdv_supportConstraints: [NSLayoutConstraint]!
    
    private func configureConstraints(superView: UIView) {
        if sdv_supportConstraints != nil && !sdv_supportConstraints.isEmpty{
            NSLayoutConstraint.deactivate(sdv_supportConstraints)
            self.removeConstraints(sdv_supportConstraints)
        }
        
        if sdv_anchorConstraint != nil {
            NSLayoutConstraint.deactivate([sdv_anchorConstraint])
            self.removeConstraint(sdv_anchorConstraint)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        sdv_sizeConstraint = createSizeConstraint()
        sdv_anchorConstraint = createAnchorConstraint(superView: superView)
        sdv_supportConstraints = createSupportConstraints(superView: superView)
        
        NSLayoutConstraint.activate([sdv_anchorConstraint, sdv_sizeConstraint])
        NSLayoutConstraint.activate(sdv_supportConstraints)
        
        _currentSDVState = .collapsed
        setCurrentStateConstraints(state: _currentSDVState)
        self.isHidden = true
        
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
        switch anchor {
        case .bottom:
            if bottomLayoutGuide != nil {
                anchorConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide!, attribute: .top, multiplier: 1.0, constant: 0.0)
            }else {
                anchorConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            }
        case .top:
            if topLayouyGuide != nil {
                anchorConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: topLayouyGuide!, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            }else {
                anchorConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 0.0)
            }
        case .left, .right:
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
    
    private func getAssiociatedLayoutAttribute(anchor: SlidingSideViewAnchor) -> NSLayoutAttribute {
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
    
    private func checkAnchorInvertionStatus(forAnchor anchor: SlidingSideViewAnchor) -> Bool {
        switch anchor {
        case .top, .left:
            return true
        case .bottom, .right :
            return false
        }
    }
    
    //MARK: Animation
    
    private func animateChanges() {
        delegate?.slidingDetailView(self, willSlideToState: _currentSDVState)
        self.isHidden = false
        UIView.animate(withDuration: _animationDuration, delay: 0.0, options: [], animations: { 
            self.superview?.layoutIfNeeded()
        }) { (_) in
            if self._currentSDVState == .collapsed {
                self.isHidden = true
            }
            self.delegate?.slidingDetailView(self, didSlideToState: self._currentSDVState)
        }
    }
    
    private func setCurrentStateConstraints(state: SlidingSideViewState) {
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

}
