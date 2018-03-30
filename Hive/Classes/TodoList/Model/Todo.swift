//
//  Todo.swift
//  Hive
//
//  Created by Leon Luo on 11/8/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {
        
    @objc enum Status: Int {
        case pending = 0
        case resolved = 1
        case deleted = 2
    }
    
    @objc enum Urgency: Int {
        case normal = 0
        case important = 1
        case urgent = 2
        case urgentAndImportant = 3
    }
    
    @objc enum Category: Int {
        case todo = 0
    }

    @objc dynamic var todoId = NSUUID().uuidString
    @objc dynamic var title: String?
    let subItems = List<String>()
    @objc dynamic var category: Category = .todo
    @objc dynamic var status: Status = .pending
    @objc dynamic var level: Urgency = .normal
    @objc dynamic var createdAt = Date()
    @objc dynamic var modifiedAt: Date? = nil
    @objc dynamic var finishedAt: Date? = nil
    @objc dynamic var deletedAt: Date? = nil
    @objc dynamic var promoteAt: Date? = nil
    @objc dynamic var image: Data? = nil
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    override static func primaryKey() -> String? {
        return "todoId"
    }
}

