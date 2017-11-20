//
//  TodoItem.swift
//  Hive
//
//  Created by Leon Luo on 11/3/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

class TodoItem: NSObject {
    var idx: Int
    var title: String
    
    static var writableTypeIdentifiersForItemProvider: [String] = ["TodoItem"]
    
    required init(at index: Int, title content: String) {
        idx = index
        title = content
    }
    
    convenience init(idx: Int, title: String) {
        self.init(at: idx, title: title)
    }
    
    convenience override init() {
        self.init()
    }
}

extension TodoItem: NSItemProviderWriting {
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return Progress()
    }
}

extension TodoItem: NSItemProviderReading {
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        return self.init(at: 1, title: "title")
    }
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return writableTypeIdentifiersForItemProvider
    }
    
}
