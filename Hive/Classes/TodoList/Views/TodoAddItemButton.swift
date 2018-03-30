//
//  TodoAddItemButton.swift
//  Hive
//
//  Created by Leon Luo on 11/28/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import QuartzCore

class TodoAddItemButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 1);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.25;
        self.layer.masksToBounds = false
        //        btn.layer.shadowColor = UIColor.init(hex: 0xeceff1).cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.adjustsImageWhenHighlighted = false
    }

}


class TodoAddItemButtonItem: UIView {
    
}
