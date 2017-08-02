//
//  SlidingDetailViewController.swift
//  SlidingDetailView
//
//  Created by Kacper Raczy on 25.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit

class SlidingDetailViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
