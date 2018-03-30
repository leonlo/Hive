//
//  Notes.swift
//  Hive
//
//  Created by Leon Luo on 3/22/18.
//  Copyright © 2018 leonluo. All rights reserved.
//

import UIKit
import RealmSwift

class Note: NSObject {
    @objc dynamic var notesId = NSUUID().uuidString
    var todos = List<Todo>()
    convenience init(todos: List<Todo>) {
        self.init()
        self.todos = todos
    }
}
