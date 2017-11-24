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
    
    var confirmBtn: UIButton!
    
    var urgencyBtn: UIButton!
    
    var inputTextView: TodoInputTextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor("#eeeeee")
        inputTextView = TodoInputTextView.init(frame: CGRect.zero)
        inputTextView.layer.borderColor = UIColor("#ccc")?.cgColor
        inputTextView.layer.borderWidth = 0.5
        inputTextView.placeholderAttributedText = NSAttributedString(string: "你要做些什么？",
                                                                     attributes: [NSAttributedStringKey.font: self.inputTextView.textView.font!,
                                                                                  NSAttributedStringKey.foregroundColor: UIColor.gray
            ]
        )

        inputTextView.delegates.willChangeHeight = self.textViewHeightWillChange
        inputTextView.delegates.didChangeHeight = self.textViewHeightDidChange
        
        inputTextView.textView.textContainerInset = UIEdgeInsets(top: 4, left: 3, bottom: 4, right: 3)
        inputTextView.layer.cornerRadius = 2.5
        inputTextView.backgroundColor =  UIColor(white: 0.98, alpha: 1)
        self.addSubview(inputTextView)
        
        confirmBtn = UIButton.init(type: .custom)
        confirmBtn.setTitle("S", for: .normal)
        confirmBtn.backgroundColor = .blue
        confirmBtn.addTarget(self, action: #selector(TodoInputToolBar.submitAction), for: .touchUpInside)
        self.addSubview(confirmBtn)
        
        urgencyBtn = UIButton.init(type: .custom)
        urgencyBtn.setTitle("U", for: .normal)
        urgencyBtn.backgroundColor = .red
        self.addSubview(urgencyBtn)
        
        
        inputTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(12)
            make.top.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
            make.bottom.equalTo(urgencyBtn.snp.top).offset(-6)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(urgencyBtn)
            make.right.equalTo(self).offset(-12)
            make.size.equalTo(20)
        }
        
        urgencyBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-8)
            make.left.equalTo(self).offset(12)
            make.size.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func submitAction() {
        let inputText = (self.inputTextView.textView.text?.trimmingCharacters(
            in: NSCharacterSet.whitespacesAndNewlines
            ))
        self.inputTextView.textView.resignFirstResponder()
        if (inputText?.isEmpty)! {
            return
        }
        self.delegate?.toolBar(self, didSubmit: InputItem(content: inputText!))
        self.inputTextView.textView.text = ""
    }
    
    
    override func draw(_ rect: CGRect) {
        UIColor("#ccc")?.set()
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint.init(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint.init(x: self.frame.size.width, y: 0))
        bezierPath.lineWidth = 0.5
        bezierPath.stroke()
    }
}

