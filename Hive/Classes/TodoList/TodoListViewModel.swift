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

// todo, fromIndexPath, destinationIndexPath
typealias ContentModelDidChangeHandler = (Todo, IndexPath, IndexPath) -> ()

class TodoListViewModel {
    var sortBy: SortBy = .createTime
    var todoItems: [Todo] = []
    
    var todoResults: Results<Todo>?
    var contentModelDidChangeHandler: ContentModelDidChangeHandler!
    
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
            self.mergePropertyDidChangedHandlerToCellModel(cellModel: cellModel)
            
            if todo.status == Todo.TodoStatus.pending {
                pendingSectionModel.addCellModel(cellModel)
            }
            if todo.status == Todo.TodoStatus.resolved {
                resolvedSectionModel.addCellModel(cellModel)
            }
        }

    }
    
    func mergePropertyDidChangedHandlerToCellModel(cellModel: TodoCellModel) {
        cellModel.propertyDidChangeHandler = { [weak self] (todo, map) in
            let statusKey = String.init(describing: todo.status)
            if map[statusKey] != nil {
                //                    let status = map[statusKey]
                if cellModel.status == Todo.TodoStatus.pending {
                    guard let from = self?.resolvedSectionModel.itemIndexPath(cellModel: cellModel) else {
                        return
                    }
                    let to: IndexPath! = IndexPath.init(row: 0, section: (self?.pendingSectionModel.sectionType.rawValue)!)
                    self?.move(from: from, to: to)
                    self?.callbackToUI(todo: todo, from: from, to: to)
                }
                
                if cellModel.status == Todo.TodoStatus.resolved {
                    guard let from = self?.pendingSectionModel.itemIndexPath(cellModel: cellModel) else {
                        return
                    }
                    let to: IndexPath! = IndexPath.init(row: 0, section: (self?.resolvedSectionModel.sectionType.rawValue)!)
                    self?.move(from: from, to: to)
                    self?.callbackToUI(todo: todo, from: from, to: to)
                }
                
            }
        }
    }
    
    func callbackToUI(todo: Todo, from: IndexPath, to: IndexPath) {
        if contentModelDidChangeHandler != nil {
            contentModelDidChangeHandler(todo, from, to)
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
            
            let fromCellIdx = fromSection.index(of: fromCellModel)
            fromSection.remove(at: fromCellIdx)
        }
    }
    
    func add(_ cellModel: TodoCellModel) {
        self.mergePropertyDidChangedHandlerToCellModel(cellModel: cellModel)
        if cellModel.status == .pending {
            pendingSectionModel.insert(cellModel, at: 0)
            
        } else if cellModel.status == . resolved {
            resolvedSectionModel.insert(cellModel, at: 0)
            
        } else {
            return
        }
    }
    
}


