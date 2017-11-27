//
//  TodoListViewModel.swift
//  Hive
//
//  Created by Leon Luo on 11/9/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import RealmSwift

enum SortBy: Int {
    case createTime = 1
    case priority = 2
}

class TodoListViewModel {
    var sortBy: SortBy = .createTime
    var todoItems: [Todo] = []
    
    var todoResults: Results<Todo>?
    
    // to be continue
    var sectionModels: [TodoSectionModel] = []
    var pendingSectionModel = TodoSectionModel(sectionType: .pending)
    var resolvedSectionModel = TodoSectionModel(sectionType: .resolved)
    
    
    
    init() {
        sectionModels.append(pendingSectionModel)
        sectionModels.append(resolvedSectionModel)
    }
    
    
    deinit {
        print("----- viewModel deinit -----")
    }
    
    func initData(todoResults: Results<Todo>) {
        for entity in (todoResults.enumerated()) {
            let todo = entity.element
            let cellModel = TodoCellModel.init(todo: todo)
            
            if todo.status == Todo.Status.pending {
                pendingSectionModel.addCellModel(cellModel)
            }
            if todo.status == Todo.Status.resolved {
                resolvedSectionModel.addCellModel(cellModel)
            }
        }

    }
    
    
    
    
    func move(from: IndexPath, to: IndexPath) {
        if self.sectionModels[from.section].itemCount() == 0 {
            return
        }
        if self.sectionModels[to.section].itemCount() < to.row {
            return
        }
        let fromSection = self.sectionModels[from.section]
        let toSection = self.sectionModels[to.section]
        if fromSection == toSection {
            toSection.move(fromIdx: from.row, toIdx: to.row)
        } else {
            let fromCellModel = self.sectionModels[from.section].cellModels[from.row]
            toSection.insert(fromCellModel, at: to.row)
            if toSection.sectionType == .resolved {
                fromCellModel.status = .resolved
            }
            if toSection.sectionType == .pending {
                fromCellModel.status = .pending
            }
            
            let fromCellIdx = fromSection.index(of: fromCellModel)
            fromSection.remove(at: fromCellIdx)
        }
    }
    
    func add(_ cellModel: TodoCellModel) {
        if cellModel.status == .pending {
            pendingSectionModel.insert(cellModel, at: 0)
            
        } else if cellModel.status == . resolved {
            resolvedSectionModel.insert(cellModel, at: 0)
            
        } else {
            return
        }
    }
    
    func remove(at indexPath: IndexPath) {
        self.sectionModels[indexPath.section].cellModels.remove(at: indexPath.row)
    }
    
    func remove(_ cellModel: TodoCellModel) {
        guard let indexPath = self.itemIndexPath(cellModel: cellModel) else { return }
        self.sectionModels[indexPath.section].cellModels.remove(at: indexPath.row)
    }
    
    
    func itemIndexPath(cellModel: TodoCellModel) -> IndexPath? {
        var indexPath: IndexPath!
        for sectionModel in sectionModels.enumerated() {
            if sectionModel.element.itemIndexPath(cellModel: cellModel) != nil{
                indexPath = sectionModel.element.itemIndexPath(cellModel: cellModel)
            }
        }
        return indexPath
    }

    
    func pendingSection() -> Int {
        return pendingSectionModel.sectionType.rawValue
    }
    
    func resolvedSection() -> Int {
        return resolvedSectionModel.sectionType.rawValue
    }
}


