//
//  AddItemIconView.swift
//  Hive
//
//  Created by Leon Luo on 11/7/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

class PullToAddView: UIView {

    var icon: UIImageView!
    var maximizeSize: CGFloat!
    
    init(height: CGFloat, iconMaximizeSize: CGFloat) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        self.maximizeSize = iconMaximizeSize
        icon = UIImageView.init(image: #imageLiteral(resourceName: "ic_alarm"))
        icon.backgroundColor = Specs.color.themePrimaryColor
        icon.layer.masksToBounds = false
        self.addSubview(icon)
        
        icon.frame.size = CGSize.init(width: 1, height: 1)
        setIconCenter()
    }
    
    func setIconSize(size: CGSize) {
        icon.frame.size = size
        icon.layer.cornerRadius = size.width / 2
        self.setIconCenter()
    }
    
    fileprivate func setIconCenter() {
        var center = self.icon.center
        center.x = UIScreen.main.bounds.width / 2
        center.y = self.frame.size.height / 2
        self.icon.center = center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
