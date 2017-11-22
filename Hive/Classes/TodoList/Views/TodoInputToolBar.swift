//
//  TodoInputToolBar.swift
//  Hive
//
//  Created by Leon Luo on 11/8/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

class TodoInputToolBar: UIView {
    
    var delegate: TodoInputToolBarProtocol! = nil
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var inputTextfiled: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let inputText = (self.inputTextfiled.text?.trimmingCharacters(
            in: NSCharacterSet.whitespacesAndNewlines
            ))
        if (inputText?.isEmpty)! {
            return
        }
        self.delegate?.toolBar(self, didSubmit: InputItem(content: inputText!))
        self.inputTextfiled.resignFirstResponder()
        self.inputTextfiled.text = ""
    }
    
    override func awakeFromNib() {
        
    }
    
    
    
}
