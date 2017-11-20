//
//  SQLiteManager.swift
//  Hive
//
//  Created by Leon Luo on 11/9/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import SQLite

class SQLiteManager: NSObject {
    
    static let shared = SQLiteManager()
    
    var debugMode = true
    
    var database: Connection?
    var databasePath: String?
    var databaseName: String?
    
    let todo = Table("t_todo")
    let tag = Table("t_tag")
    
    let id = Expression<Int64>("TODO_ID") // primary key
    let status = Expression<Int64>("STATUS")
    let level = Expression<Int64>("LEVEL")
    let title = Expression<String>("TITLE")
    let subItems = Expression<Blob?>("SUBITEMS")
    let createdAt = Expression<Int64>("CREATE_AT")
    let updatedAt = Expression<Int64?>("UPDATE_AT")
    let finishedAt = Expression<Int64?>("FINISH_AT")
    let deletedAt = Expression<Int64?>("DELETE_AT")
    
    
    class func openDB() {
        var manager = SQLiteManager.shared
        let databasePath: String = NSHomeDirectory() + "/DB"
        manager = manager.openDB(dbName: "todo", dbPath: databasePath)
        
        if !manager.tableExists(tableName: "t_todo") {
            do {
                try manager.database?.run(manager.todo.create { t in
                    t.column(manager.id, primaryKey: .autoincrement)
                    t.column(manager.status, defaultValue: 0)
                    t.column(manager.level, defaultValue: 0)
                    t.column(manager.title)
                    t.column(manager.subItems)
                    t.column(manager.createdAt, defaultValue: Int64(Date().timeIntervalSince1970 * 1000))
                    t.column(manager.updatedAt)
                    t.column(manager.deletedAt)
                })
            } catch { manager.sqlitePrint(error) }
        }
        
//        if !manager.tableExists(tableName: "t_tag") {
//            do {
//                try manager.database?.run(manager.tag.create(t in
//                    t.column()
//                ))
//            }
//        }
    }
    
    class func insert(toTodo title: String) {
        let manager = SQLiteManager.shared
        do {
            let insert = manager.todo.insert(manager.title <- title)
            try manager.database?.run(insert)
        } catch {
            manager.sqlitePrint(error)
        }
    }
    
    class func queryAll(fromTable: String) -> [Any] {
        var result: [Any] = [Any].init()
        return result
    }
    
//    class func update(fromTodo title: String, `where` id: String) {
//        let manager = SQLiteManager.shared
//
//    }
    
}

extension SQLiteManager {
    
    func defaultPath() -> String {
        return NSHomeDirectory()
    }
    
    @discardableResult
    func openDB(dbName: String, dbPath: String) -> SQLiteManager {
        self.database = try? Connection("\(dbPath)/\(dbName).db")
        self.databaseName = dbName
        self.databasePath = dbPath
        //        if let db = Connection("\(dbPath)/\(dbName)") {
        //            return nil
        //        }
        return self
    }
    
    func insert(object: Any, into table: String) {
        
    }
    
    func update(object: Any, from table: String) {
        
    }
    
    func select(from table: String, sqlWhere sql: String) -> [[String:AnyObject]] {
        let sqlStr = ""

        let results = prepare(sqlStr)
        return results
    }
    
    func delete(from table: String, sqlWhere sql: String) {
        if tableExists(tableName: table) == false {
            return
        }
        let sqlStr = "DELETE FROM \(table) WHERE \(sql)"
        // self.execute(sqlStr)
    }

    
    func prepare(_ sqlStr: String) -> [[String:AnyObject]] {
        let results = try! self.database?.prepare(sqlStr)
        var elements:[[String:AnyObject]] = []
        if let results = results{
            let colunmSize = results.columnNames.count
            for row in results  {
                var record:[String: AnyObject] = [:]
                for i in 0..<colunmSize {
                    let value   = row[i]
                    let key     = results.columnNames[i] as String
                    
                    if let value = value {
                        record.updateValue(value as AnyObject, forKey: key)
                    }
                }
                elements.append(record)
            }
            return elements
        }else{
            return elements
        }
    }
    
    func tableExists(tableName: String) -> Bool {
        guard database != nil else {
            return false
        }
        do {
            let isExists = try database?.scalar(
                "SELECT EXISTS (SELECT * FROM sqlite_master WHERE type = 'table' AND name = ?)", tableName
                ) as! Int64 > 0
            sqlitePrint("数据库表:\(isExists == true ? "存在" : "不存在")")
            return isExists
        }catch {
            sqlitePrint(error)
            return false
        }
    }


    /// 统一的打印
    ///
    /// - Parameter printObj: 打印的内容
    func sqlitePrint(_ printObj:Any){
        if debugMode == true {
            print(printObj)
        }
    }

    
}
