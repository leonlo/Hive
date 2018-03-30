//
//  TodoInputToolBar.swift
//  Hive
//
//  Created by Leon Luo on 11/8/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

class TodoInputToolBar: UIView {
    
    var textViewHeightWillChange: (CGFloat) -> Void = { _ in }
    var textViewHeightDidChange: (CGFloat) -> Void = { _ in }
    
    var delegate: TodoInputToolBarProtocol! = nil
    
    
    fileprivate var alarmBtn: UIButton!
    
    fileprivate var closeBtn: UIButton!
    
    fileprivate var inputTextView: TodoInputTextView!
    
    fileprivate var textInputBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.99, alpha: 1)
        view.layer.borderColor = UIColor.init(hex: 0xfafafa).cgColor
        view.layer.borderWidth = 0.5
        view.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var datePickerPannel: TodoDatePickerPannel = {
        let pannel = TodoDatePickerPannel()
        return pannel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(hex: 0xfafafa)
        
        inputTextView = {
            let view = TodoInputTextView.init(frame: CGRect.zero)
            view.backgroundColor =  UIColor(white: 0.99, alpha: 1)
            view.layer.cornerRadius = 4
            view.placeholderAttributedText = NSAttributedString(string: "你要做什么？",
                                                                         attributes: [NSAttributedStringKey.font: view.textView.font!,
                                                                                      NSAttributedStringKey.foregroundColor: UIColor.init(hex: 0xc2c2c2)
                ]
            )
            view.delegates.willChangeHeight = self.textViewHeightWillChange
            view.delegates.didChangeHeight = self.textViewHeightDidChange
            view.textView.textContainerInset = UIEdgeInsets(top: 8, left: 3, bottom: 8, right: 3)
            view.textView.returnKeyType = .send
            view.textView.delegate = self
            return view
        }()
        
        
        alarmBtn = {
            let btn = UIButton.init(type: .custom)
            btn.setImage(#imageLiteral(resourceName: "ic_remind"), for: .normal)
            btn.layer.masksToBounds = false
            
            btn.imageEdgeInsets = UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
            btn.backgroundColor = UIColor.init(white: 0.99, alpha: 0.9)
            btn.addTarget(self, action: #selector(TodoInputToolBar.showDatePickerPannel), for: .touchUpInside)
            return btn
        } ()
        
        closeBtn = {
            let btn = UIButton.init(type: .custom)
            btn.setImage(#imageLiteral(resourceName: "ic_keyboard_dismiss"), for: .normal)
            btn.layer.masksToBounds = false
            
            btn.imageEdgeInsets = UIEdgeInsets.init(top: 4.5, left: 4.5, bottom: 7, right: 4.5)
            btn.backgroundColor = UIColor.init(white: 0.99, alpha: 0.9)
            btn.addTarget(self, action: #selector(TodoInputToolBar.dismisKeyboard), for: .touchUpInside)
            return btn
        }()
        
        self.addSubview(textInputBackgroundView)
        self.addSubview(inputTextView)
        self.addSubview(alarmBtn)
        self.addSubview(closeBtn)
        
    
        textInputBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(inputTextView).offset(-2)
            make.bottom.equalTo(inputTextView).offset(2)
            make.left.equalTo(inputTextView).offset(-2)
            make.right.equalTo(inputTextView).offset(2)
        }
        
        inputTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(12)
            make.top.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
            make.bottom.equalTo(alarmBtn.snp.top).offset(-12)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-8)
            make.bottom.equalTo(self).offset(-8)
            make.size.equalTo(30)
        }
        
        alarmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.centerY.equalTo(closeBtn)
            make.size.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
    }
    
    @objc func submitAction() {
        let inputText = (self.inputTextView.textView.text?.trimmingCharacters(
            in: NSCharacterSet.whitespacesAndNewlines
            ))
        self.dismisKeyboard()
        if (inputText?.isEmpty)! {
            return
        }
        self.delegate?.toolBar(self, didSubmit: InputItem(content: inputText!))
        self.inputTextView.textView.text = ""
    }
    
    func showKeyboard() {
        self.inputTextView.textView.becomeFirstResponder()
        TodoDatePickerPannel.setFrame(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: UIScreen.main.bounds.size.width, height: self.frame.origin.y))) 
    }
    
    @objc func dismisKeyboard() {
        self.inputTextView.textView.resignFirstResponder()
        TodoDatePickerPannel.dismiss()
    }
    
    @objc func showDatePickerPannel() {
        TodoDatePickerPannel.changeStatus()
    }
    
    override func draw(_ rect: CGRect) {
        Specs.color.separator.set()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint.init(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint.init(x: self.frame.size.width, y: 0))
        bezierPath.lineWidth = 0.5
        bezierPath.stroke()
    }
    
    
}

extension TodoInputToolBar: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            submitAction()
            return false
        }
        return true
    }
}

