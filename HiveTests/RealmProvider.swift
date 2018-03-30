//
//  RealmProvider.swift
//  HiveTests
//
//  Created by Leon Luo on 11/28/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import RealmSwift

class RealmProvider: NSObject {
    class func realm() -> Realm {
        return try! Realm()
    }
    
}
