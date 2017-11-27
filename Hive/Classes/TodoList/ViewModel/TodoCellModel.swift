//
//  TodoItemCellModel.swift
//  Hive
//
//  Created by Leon Luo on 11/8/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import RealmSwift

enum TodoPropertyChangedKey: String {
    case status = "status"
}

typealias PropertyDidChangeHandler = (Todo, [String: Any]) -> ()

class TodoCellModel: NSObject {
    
    static var identifiersForItemProvider: [String] = ["TodoItem"]

    enum Category {
        case todo
        case reminder
    }
    
    var todo: Todo!
    var indexPath: IndexPath!
    var propertyDidChangeHandler: PropertyDidChangeHandler!
    
    var expanded: Bool = false
    var type: Category = .todo
    var status: Todo.Status = .pending
//    {
//        didSet {
//            // 导致了 todo statuschange 后
//            if self.propertyDidChangeHandler != nil {
//                self.propertyDidChangeHandler(todo, [TodoPropertyChangedKey.status.rawValue : status.rawValue])
//            }
//        }
//    }
    var title: String
    var image: NSData!
    var createdAt: Date!
    var finishedAt: Date?
    var level: Todo.Urgency = .normal
    
    
        
    init(title: String) {
        self.title = title
    }
    
   required init(todo object: Todo) {
        self.todo = object
        
        self.title = object.title!
        self.createdAt = object.createdAt
        self.status = object.status
        self.level = object.level
        self.finishedAt = object.finishedAt
    }
    
}

extension TodoCellModel: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return identifiersForItemProvider
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        return self.init(todo: Todo.init(title: ""))
    }
    
    
}

extension TodoCellModel: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return identifiersForItemProvider
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//        completionHandler(self, nil)
        return Progress()
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
