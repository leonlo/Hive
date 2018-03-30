//
//  TaskManagerTest.swift
//  HiveTests
//
//  Created by Leon Luo on 11/28/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import XCTest
@testable import Hive
@testable import RealmSwift

class TaskManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetch() {
        let results:Results<Todo> = TodoTaskManager.fetch()
        print(results)
        XCTAssert(true, results.description)
    }
    
    func testQueryTodo() {
        guard let todo: Todo = TodoTaskManager.find(id: "9B4AAC4E-98F6-4700-86A7-23555DF1680B") else { return }
        print(todo)
    }
    
    func testQueryAllPerformance() {
        self.measure {
            self.testFetch()
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }
    
}
