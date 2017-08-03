//
//  ViewController.swift
//  SlidingSideViewDemo
//
//  Created by Kacper Raczy on 24.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit
import SlidingSideView

class DemoViewController: UIViewController {

    var slidingDetailView: SlidingSideView!
    var slidingDetailAnchor: SlidingSideViewAnchor!
    var label: UILabel!
    
    @IBOutlet weak var slideImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if slidingDetailAnchor == nil {
            slidingDetailAnchor = .bottom
        }
        
        setupToolbar()
        setupSlideImage()
        
        slidingDetailView = SlidingSideView(slidingDetailAnchor ,withNormalHeight: 100.0, expandedHeight: 200.0)
        slidingDetailView.backgroundColor = UIColor.clear
        slidingDetailView.delegate = self
        
        //set layoutguides before adding as a subview
        slidingDetailView.topLayouyGuide = self.topLayoutGuide
        slidingDetailView.bottomLayoutGuide = self.bottomLayoutGuide
        
        self.view.addSubview(slidingDetailView)
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor(red: 0.0, green: 129.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.white
        
        contentView.addSubview(label)
        let labelCenter = label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0)
        let labelLeading = label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0)
        let labelTrailing = label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0)
        NSLayoutConstraint.activate([labelCenter,labelLeading,labelTrailing])
        
        slidingDetailView.addSubview(contentView)
        configureViewLayout(view: contentView)
    
    }
    
    func normalSlide(_ sender: Any) {
        slidingDetailView.currentState = .normal
        label.text = String(format: "State: Normal, Height: %g", slidingDetailView.normalHeight)
    }

    func extendedSlide(_ sender: Any) {
        slidingDetailView.currentState = .expanded
        label.text = String(format: "State: Expanded, Height: %g", slidingDetailView.expandedHeight!)
    }
    
    func close(_ sender: Any) {
        slidingDetailView.currentState = .collapsed
        label.text = "State: Collapsed"
    }
    
    func configureViewLayout(view: UIView) {
        let top = view.topAnchor.constraint(equalTo: self.slidingDetailView.topAnchor, constant: 0.0)
        let bottom = view.bottomAnchor.constraint(equalTo: self.slidingDetailView.bottomAnchor, constant: 0.0)
        let leading = view.leadingAnchor.constraint(equalTo: self.slidingDetailView.leadingAnchor, constant: 0.0)
        let trailing = view.trailingAnchor.constraint(equalTo: self.slidingDetailView.trailingAnchor, constant: 0.0)
        NSLayoutConstraint.activate([top,bottom,leading,trailing])
    }
    
    func setupSlideImage() {
        var image: UIImage!
        switch slidingDetailAnchor! {
        case .top:
            image = UIImage(named: "top.png")
        case .bottom:
            image = UIImage(named: "bottom.png")
        case .left:
            image = UIImage(named: "left.png")
        case .right:
            image = UIImage(named: "right.png")
        }
        self.slideImageView.image = image
    }
    
    func setupToolbar() {
        let normalBtn = UIBarButtonItem(title: "Normal", style: .plain, target: self, action: #selector(normalSlide(_:)))
        let extendedBtn = UIBarButtonItem(title: "Extended", style: .plain, target: self, action: #selector(extendedSlide(_:)))
        let closeBtn = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close(_:)))
        closeBtn.tintColor = UIColor.red
        
        self.toolbarItems = [normalBtn, extendedBtn, closeBtn]
    }
}

extension DemoViewController: SlidingSideViewDelegate {
    
    public func slidingDetailView(_ sdView: SlidingSideView, willSlideToState state: SlidingSideViewState) {
        print("Will slide")
    }
    
    func slidingDetailView(_ sdView: SlidingSideView, didSlideToState state: SlidingSideViewState) {
        print("Did slide")
    }
}
