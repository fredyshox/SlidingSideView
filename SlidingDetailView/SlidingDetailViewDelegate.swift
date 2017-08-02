//
//  SlidingDetailViewDelegate.swift
//  SlidingDetailView
//
//  Created by Kacper Raczy on 28.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import Foundation


public protocol SlidingDetailViewDelegate {
    func slidingDetailView(_ sdView: SlidingDetailView, willSlideToState state: SlidingDetailViewState);
    func slidingDetailView(_ sdView: SlidingDetailView, didSlideToState state: SlidingDetailViewState);
}

extension SlidingDetailViewDelegate {
    func slidingDetailView(_ sdView: SlidingDetailView, willSlideToState state: SlidingDetailViewState){}
    func slidingDetailView(_ sdView: SlidingDetailView, didSlideToState state: SlidingDetailViewState){}
}
