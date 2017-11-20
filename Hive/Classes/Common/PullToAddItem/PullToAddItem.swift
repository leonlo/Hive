//
//  PullToAddItem.swift
//  Hive
//
//  Created by Leon Luo on 11/7/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import PullToRefresh

class PullToAddItem: PullToRefresh {
    
//    init(refreshView: UIView, animator: RefreshViewAnimator, position: Position) {
//        let height: CGFloat = 100
//        refreshView.backgroundColor = UIColor.white
//        refreshView.translatesAutoresizingMaskIntoConstraints = false
//        refreshView.autoresizingMask = [.flexibleWidth]
//        refreshView.frame.size.height = height
//
//        super.init(refreshView: refreshView, animator: animator, height: height, position: position)
//    }
    var pullToAddView: PullToAddView!
    
    override init(refreshView: UIView, animator: RefreshViewAnimator, height: CGFloat, position: Position) {
        self.pullToAddView = refreshView as! PullToAddView

        super.init(refreshView: refreshView, animator: animator, height: height, position: position)
    }
    
   convenience init(at position: Position) {
        let height: CGFloat = 100
        let view = PullToAddView.init(height: height, iconMaximizeSize: 40)
        view.backgroundColor = UIColor.white
        let animator = PullToAddAnimator(pullToAddView: view)

        self.init(refreshView: view, animator: animator, height: height, position: position)
    }
    
}
