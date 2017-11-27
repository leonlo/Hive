//
//  TodoInputToolBarProtocol.swift
//  Hive
//
//  Created by Leon Luo on 11/15/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

class InputItem: NSObject {
    var content: String
    var urgency: Todo.Urgency!
    
    init(content text: String, urgency level: Todo.Urgency) {
        self.urgency = level
        self.content = text
    }
    
    convenience init(content text: String) {
        self.init(content: text, urgency: .normal)
    }
}

protocol TodoInputToolBarProtocol: class {
    func toolBar(_ toolBar: TodoInputToolBar, didSubmit input: InputItem)
}
