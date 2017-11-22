//
//  TodoItemCellDelegate.swift
//  Hive
//
//  Created by Leon Luo on 10/19/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

protocol TodoItemCellProtocol: class {
    
    
   // func didfinishedDrawing(_ cell: TodoItemCell)
    
    
    func cell(didBeganSpanning cell: TodoItemCell)
    func cell(_ todoItemCell: TodoItemCell, didSpanningIn progress: CGFloat)
    func cell(didEndedSpanning cell: TodoItemCell) -> Bool

}

extension TodoItemCellProtocol {
    
}


