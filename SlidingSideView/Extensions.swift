//
//  Extensions.swift
//  SlidingSideView
//
//  Created by Kacper Raczy on 27.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit


extension UIWindow {
    public var visibleViewController: UIViewController? {
        get {
            return getDeepestPresentedViewController(from: rootViewController)
        }
    }
    
    public func getDeepestPresentedViewController(from vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return getDeepestPresentedViewController(from: nc.visibleViewController)
        }else if let tbc = vc as? UITabBarController {
            return getDeepestPresentedViewController(from: tbc.selectedViewController)
        }else {
            if let pvc = vc?.presentedViewController {
                return getDeepestPresentedViewController(from: pvc)
            }else {
                return vc
            }
        }
    }
}


extension UIView {
    func snapshotImage() -> UIImage?{
        UIGraphicsBeginImageContext(self.bounds.size)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    func snapshotView() -> UIView?{
        if let image = snapshotImage() {
            return UIImageView(image: image)
        }else {
            return nil
        }
    }
}
