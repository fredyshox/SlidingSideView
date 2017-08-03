//
//  ViewController.swift
//  SlidingDetailViewDemo
//
//  Created by Kacper Raczy on 24.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit
import SlidingDetailView

class DemoViewController: UIViewController {

    var slidingDetailView: SlidingDetailView!
    var slidingDetailAnchor: SlidingDetailViewAnchor!
    var vc: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if slidingDetailAnchor == nil {
            slidingDetailAnchor = .bottom
        }
        
        setupToolbar()
        
        slidingDetailView = SlidingDetailView(slidingDetailAnchor ,withNormalHeight: 100.0, expandedHeight: 200.0)
        slidingDetailView.backgroundColor = UIColor.cyan
        slidingDetailView.delegate = self
        
        slidingDetailView.topLayouyGuide = self.topLayoutGuide
        slidingDetailView.bottomLayoutGuide = self.bottomLayoutGuide
        
        
        
//        vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
//        //addChildViewController(vc)
//        //vc.loadView()
//        vc.view.translatesAutoresizingMaskIntoConstraints = false
//        let v = vc.view
//        slidingDetailView.addSubview(v!)
//        let top = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: slidingDetailView, attribute: .top, multiplier: 1.0, constant: 0.0)
//        let bottom = NSLayoutConstraint(item: v, attribute: .bottom, relatedBy: .equal, toItem: slidingDetailView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
//        let leading = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: slidingDetailView, attribute: .leading, multiplier: 1.0, constant: 0.0)
//        let trailing = NSLayoutConstraint(item: v, attribute: .trailing, relatedBy: .equal, toItem: slidingDetailView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
//        NSLayoutConstraint.activate([top,bottom,leading,trailing])
        //vc.didMove(toParentViewController: self)
        
        

        
        self.view.addSubview(slidingDetailView)
    
    }
    
    func normalSlide(_ sender: Any) {
        slidingDetailView.currentState = .normal
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func extendedSlide(_ sender: Any) {
        slidingDetailView.currentState = .expanded
    }
    
    func close(_ sender: Any) {
        slidingDetailView.currentState = .collapsed
    }
    
    func setupToolbar() {
        let normalBtn = UIBarButtonItem(title: "Normal", style: .plain, target: self, action: #selector(normalSlide(_:)))
        let extendedBtn = UIBarButtonItem(title: "Extended", style: .plain, target: self, action: #selector(extendedSlide(_:)))
        let closeBtn = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close(_:)))
        closeBtn.tintColor = UIColor.red
        
        self.toolbarItems = [normalBtn, extendedBtn, closeBtn]
    }
}

extension DemoViewController: SlidingDetailViewDelegate {
    
    public func slidingDetailView(_ sdView: SlidingDetailView, willSlideToState state: SlidingDetailViewState) {
        print("will slide")
    }
}
