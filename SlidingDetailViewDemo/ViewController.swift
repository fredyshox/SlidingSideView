//
//  ViewController.swift
//  SlidingDetailViewDemo
//
//  Created by Kacper Raczy on 24.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit
import SlidingDetailView

class ViewController: UIViewController {

    var slidingDetailView: SlidingDetailView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        slidingDetailView = SlidingDetailView(withNormalHeight: 150.0, expandedHeight: 300.0)
        slidingDetailView.backgroundColor = UIColor.cyan
        
        
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

//extension ViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let animator = SlidingDetailAnimationController(originFrame: slidingDetailView.frame)
//        animator.view = slidingDetailView
//        return animator
//    }
//}
