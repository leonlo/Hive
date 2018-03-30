//
//  PullToAddAnimator.swift
//  Hive
//
//  Created by Leon Luo on 11/7/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import Foundation
import PullToRefresh

class PullToAddAnimator: RefreshViewAnimator {
    
    
    fileprivate let pullToAddView: PullToAddView
    
    init(pullToAddView: PullToAddView) {
        self.pullToAddView = pullToAddView
    }
    
    func animate(_ state: State) {
        switch state {
        case .initial:
            layoutInitialState()
        case .releasing(let progress):
            layoutReleasingState(with: progress)
        case .loading:
            layoutLoadingState()
        case .finished:
            layoutInitialState()
        }
    }
    
    
}

fileprivate extension PullToAddAnimator {
    
    func layoutInitialState() {


    }
    
    func layoutReleasingState(with progress: CGFloat) {
        let maximizeSize = pullToAddView.maximizeSize
        pullToAddView.setIconSize(size: CGSize.init(width: progress * maximizeSize!, height: progress * maximizeSize!))  
    }
    
    func layoutLoadingState() {
    }
    
    func layoutFinishState() {
        
    }
    
}
