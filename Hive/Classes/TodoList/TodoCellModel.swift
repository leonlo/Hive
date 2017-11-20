//
//  TodoItemCellModel.swift
//  Hive
//
//  Created by Leon Luo on 11/8/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import RealmSwift

typealias PropertyDidChangeHandler = (Todo, [String: Any]) -> ()

class TodoCellModel: NSObject {
        
    enum Category {
        case todo
        case reminder
    }
    
    var todo: Todo!
    var indexPath: IndexPath!
    var propertyDidChangeHandler: PropertyDidChangeHandler!
    
    var expanded: Bool = false
    var type: Category = .todo
    var status: Todo.TodoStatus = .pending {
        didSet {
            if self.propertyDidChangeHandler != nil {
                self.propertyDidChangeHandler(todo, [String.init(describing: Todo.TodoStatus.self) : status.rawValue])
            }
        }
    }
    var title: String
    var image: NSData!
    var createdAt: Date!
    var finishedAt: Date?
    var level: Todo.TodoLevel = .normal
    
    
    init(title: String) {
        self.title = title
    }
    
    init(todo object: Todo) {
        self.todo = object
        
        self.title = object.title!
        self.createdAt = object.createdAt
        self.status = object.status
        self.level = object.level
        self.finishedAt = object.finishedAt
    }
    
}

extension UIImage {
    func covertImageToData() -> Data {
        return UIImagePNGRepresentation(self)!
    }
}

extension Data {
    func covertDataToImage() -> UIImage {
        return UIImage.init(data: self)!
    }
}
