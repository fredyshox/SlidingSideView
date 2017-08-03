//
//  SlidingSideViewDelegate.swift
//  SlidingSideView
//
//  Created by Kacper Raczy on 28.07.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import Foundation


public protocol SlidingSideViewDelegate {
    func slidingDetailView(_ sdView: SlidingSideView, willSlideToState state: SlidingSideViewState);
    func slidingDetailView(_ sdView: SlidingSideView, didSlideToState state: SlidingSideViewState);
}

extension SlidingSideViewDelegate {
    func slidingDetailView(_ sdView: SlidingSideView, willSlideToState state: SlidingSideViewState){}
    func slidingDetailView(_ sdView: SlidingSideView, didSlideToState state: SlidingSideViewState){}
}
