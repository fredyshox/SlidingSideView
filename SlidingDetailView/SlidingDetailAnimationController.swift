//
//  SlidingDetailTransitionDelegate.swift
//  SlidingDetailView
//
//  Created by Kacper Raczy on 25.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit

public class SlidingDetailAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    public init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    internal var originFrame: CGRect!
    public var view: UIView!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = transitionContext.view(forKey: .to)!
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        toView.frame = originFrame
        //toView.alpha = 0.0
        
        containerView.addSubview(toView)
        
        //let snapshotIV = view.snapshotView()!
        //snapshotIV.frame = originFrame
        
        //containerView.addSubview(snapshotIV)
        
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseInOut, animations: { 
            toView.frame = finalFrame
           // snapshotIV.frame.origin = CGPoint(x: self.originFrame.origin.x, y: finalFrame.origin.y - snapshotIV.frame.height)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
//        UIView.animateKeyframes(withDuration: 0.8, delay: 0.0, options: .calculationModeCubic, animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4, animations: { 
//                toView.alpha = 1.0
//            })
//            UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 3/4, animations: { 
//                toView.frame = finalFrame
//            })
//        }) { (_) in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
        
    
    }
}
