//
//  TodoTaskManager.swift
//  Hive
//
//  Created by Leon Luo on 11/24/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import RealmSwift

class TodoTaskManager: NSObject {
    let realm = try! Realm(configuration: Realm.Configuration())
    var realmNotificationToken: NotificationToken? = nil
    var traces: [NSError] = []
    
    static let sharedInstance = TodoTaskManager()
    
    public class func add(_ todo: Todo) {
        sharedInstance.add(todo)
    }
    
    public class func update(_ todo: Todo) {
        sharedInstance.update(todo)
    }
    
    public class func remove(_ todo: Todo) {
        sharedInstance.remove(todo, isLogic: true)
    }
    
    @discardableResult
    public class func find(id number: String) -> Todo? {
        return Todo()
    }
    
    @discardableResult
    public class func query(status code: Todo.TodoStatus) -> [Todo?] {
        return [Todo()]
    }
    
    public class func query(urgency code: Todo.TodoLevel) -> [Todo?] {
        return [Todo()]
    }
}

extension TodoTaskManager {
    fileprivate func add(_ todo: Todo) {
        do {
            try realm.write {
                realm.add(todo)
            }
        } catch let error as NSError {
            traces.append(error)
        }
    }
    
    fileprivate func update(_ todo: Todo) {
        do {
            try realm.write {
                self._modifyDateBeforeTransaction(todo)
                realm.add(todo, update: true)
            }
        } catch let error as NSError {
            traces.append(error)
        }
    }
    
    fileprivate func remove(_ todo: Todo, isLogic: Bool) {
        do {
            try realm.write {
                if isLogic {
                    todo.status = .deleted
                    todo.deletedAt = Date()
                    self._modifyDateBeforeTransaction(todo)
                    realm.add(todo, update: true)

                } else {
                    realm.delete(todo)
                }
            }
        } catch let error as NSError {
            traces.append(error)
        }
    }
    
    @discardableResult
    fileprivate func find(id number: String) -> Todo? {
        return Todo()
    }
    
    @discardableResult
    fileprivate func query(status code: Todo.TodoStatus) -> [Todo?] {
        return [Todo()]
    }
    
    fileprivate func query(urgency code: Todo.TodoLevel) -> [Todo?] {
        return [Todo()]
    }
    
    
    fileprivate func _modifyDateBeforeTransaction(_ todo: Todo) {
        todo.modifiedAt = Date()
    }
}
