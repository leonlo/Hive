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
    private override init() {}
    
    public class func add(_ todo: Todo) {
        sharedInstance.add(todo)
    }
    
    public class func update(_ todo: Todo, block: (() -> Void)) {
        sharedInstance.update(todo, block: block)
    }
    
    public class func remove(_ todo: Todo) {
        sharedInstance.remove(todo, isLogic: true)
    }
    
    public class func fetch() -> Results<Todo> {
        return sharedInstance.fetch()
    }
    
    public class func find(id number: String) -> Todo? {
        return sharedInstance.find(id: number)
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
    
    fileprivate func update(_ todo: Todo, block: (() -> Void)) {
        do {
            try realm.write {
                self._modifyDateBeforeTransaction(todo)
                block()
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
    
    fileprivate func find(id number: String) -> Todo? {
        return realm.object(ofType: Todo.self, forPrimaryKey: number)
    }
    
    fileprivate func fetch() -> Results<Todo> {
        return realm.objects(Todo.self).filter("status != 2")
    }
    
    fileprivate func _modifyDateBeforeTransaction(_ todo: Todo) {
        todo.modifiedAt = Date()
    }
}
