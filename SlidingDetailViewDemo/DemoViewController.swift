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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if slidingDetailAnchor == nil {
            slidingDetailAnchor = .bottom
        }
        
        slidingDetailView = SlidingDetailView(slidingDetailAnchor ,withNormalHeight: 100.0, expandedHeight: 200.0)
        slidingDetailView.backgroundColor = UIColor.cyan
        slidingDetailView.delegate = self
        //layoutGuides should be set before adding view as a subview
        slidingDetailView.topLayouyGuide = self.topLayoutGuide
        slidingDetailView.bottomLayoutGuide = self.bottomLayoutGuide

        
        self.view.addSubview(slidingDetailView)
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func normalSlide(_ sender: UIButton) {
        slidingDetailView.currentState = .normal
    }

    @IBAction func extendedSlide(_ sender: UIButton) {
        slidingDetailView.currentState = .expanded
    }
    
    @IBAction func close(_ sender: UIButton) {
        slidingDetailView.currentState = .collapsed
    }
}

extension DemoViewController: SlidingDetailViewDelegate {
    
    public func slidingDetailView(_ sdView: SlidingDetailView, willSlideToState state: SlidingDetailViewState) {
        print("will slide")
    }
}
