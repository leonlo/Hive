//
//  TodoSectionModel.swift
//  Hive
//
//  Created by Leon Luo on 11/15/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

enum SectionType: Int {
    case pending = 0
    case resolved = 1
}

class TodoSectionModel: NSObject {
    var cellModels: [TodoCellModel]! = []
    var sectionType: SectionType!
    
    init(sectionType type: SectionType, cellModels models: [TodoCellModel]) {
        super.init()
        self.cellModels = models
        self.sectionType = type
    }
    
    convenience init(sectionType type: SectionType) {
        self.init(sectionType: type, cellModels: [])
    }
    
    func index(of cellModel: TodoCellModel) -> Int {
        if !cellModels.contains(cellModel) {
            return -1
        }
        return cellModels.index(of: cellModel) ?? -1
    }
    
    
    func remove(at idx: Int) {
        if idx < 0 { return }
        cellModels.remove(at: idx)
    }
    
    func addCellModel(_ cellModel: TodoCellModel) {
        cellModels.append(cellModel)
    }
    
    func insert(_ newModel: TodoCellModel, at index: Int ) {
        if self.cellModels.count == 0 {
            self.cellModels.append(newModel)
            return
        }
        self.cellModels.insert(newModel, at: index)
    }
    
    func move(fromIdx: Int, toIdx: Int) {
        if fromIdx >= self.cellModels.count {
            return
        }
        let cellModel = self.cellModels[fromIdx]
        self.remove(at: fromIdx)
        self.insert(cellModel, at: toIdx)
    }
    
    func itemCount() -> Int {
        return self.cellModels.count
    }
    
    func itemIndexPath(cellModel: TodoCellModel) -> IndexPath? {
        if self.index(of: cellModel) != -1 {
            return IndexPath.init(row: self.index(of: cellModel), section: self.sectionType.rawValue)
        }
        return nil
    }
    
}
