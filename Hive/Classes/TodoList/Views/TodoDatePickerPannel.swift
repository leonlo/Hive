//
//  TodoDatePickerPannel.swift
//  Hive
//
//  Created by Leon Luo on 12/4/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

class TodoDatePickerPannel: UIView {

    var isAppeard: Bool = false
    fileprivate var realFrame: CGRect!
    
    static let shared = TodoDatePickerPannel()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func setup() {
        self.backgroundColor = UIColor.init(white: 0.99, alpha: 1)
        let picker: UIDatePicker = UIDatePicker.init(frame:CGRect.zero)
        picker.datePickerMode = .countDownTimer
        self.addSubview(picker)
        picker.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
    
    public class func changeStatus() {
        if shared.isAppeard {
            shared.dismiss()
        } else {
            shared.present()
        }
    }
    
    public class func setFrame(frame: CGRect) {
        shared.setFrame(frame: frame)
    }
    
    public class func dismiss() {
        shared.dismiss()
    }
    
    public class func present() {
        shared.present()
    }
    
    fileprivate func setFrame(frame: CGRect) {
        realFrame = frame
    }
    
    fileprivate func present() {
        self.frame = realFrame
        let window = UIApplication.shared.delegate?.window ?? nil
        UIView.animate(withDuration: 0.25) {
            window?.addSubview(self)
            window?.bringSubview(toFront: self)

        }
        isAppeard = true
    }
    
    fileprivate func dismiss() {
        window?.sendSubview(toBack: self)
        self.removeFromSuperview()
        isAppeard = false
    }
    
}
