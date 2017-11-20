//
//  TodoListVC.swift
//  Hive
//
//  Created by Leon Luo on 10/18/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import SnapKit
import PullToRefresh
import RealmSwift

@available(iOS 11.0, *)
class TodoListVC: UIViewController {
    
    
    var dragIndexPath: IndexPath!
    let pullToAddItem = PullToAddItem(at: .top)
    
    let realm = try! Realm(configuration: Realm.Configuration())
    var realmNotificationToken: NotificationToken? = nil

    
    // ViewModel
    var viewModel: TodoListViewModel = TodoListViewModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.contentModelDidChangeHandler = {[weak self] (todo, from, to) in
            print("\(todo)")
            try! self?.realm.write {
                
//                todo.status = value[String.init(describing: Todo.TodoStatus.self)] as! Int == 0 ? Todo.TodoStatus.pending : Todo.TodoStatus.resolved
                self?.realm.add(todo, update: true)
                self?.todoList.moveRow(at: from, to: to)
            }
        }
        
        self.view.addSubview(self.todoList)
        self.view.addSubview(self.toolBar)
        self.toolBar.snp.makeConstraints({ (make) in
            make.bottom.equalTo(100)
            make.height.equalTo(88)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        })
        
        self.todoList.register(UINib.init(nibName: "TodoItemCell", bundle: nil), forCellReuseIdentifier: "cellId")
        
        self.todoList.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.view)
        }
        self.todoList.addPullToRefresh(pullToAddItem) { [weak self] in
            self?.todoList.endRefreshing(at: .top)
        }
        self.setupAddItemBtn()
        
    
        NotificationCenter.default.addObserver(self, selector: #selector(TodoListVC.keyboardWillHide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TodoListVC.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TodoListVC.keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        
//        self.initDataFromDB()
        self.initDB()
        
}
    
    deinit {
        self.todoList.removePullToRefresh(at: .top)
    
        // @TODO remove observer
//        NSNotification.default.remove
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    lazy var todoList: UITableView = {
        let list = UITableView(frame: CGRect.zero, style: .plain)
        list.dataSource = self
        list.delegate = self
        list.dragDelegate = self
        list.dropDelegate = self
        list.dragInteractionEnabled = false
        list.showsVerticalScrollIndicator = false
        list.backgroundColor = UIColor.init(red: 242, green: 242, blue: 242, alpha: 1)
        // @TODO separator
        list.separatorStyle = .none
        return list
    }()
    
    lazy var dataSource: Array<TodoItem> = {
        var tempArray: Array<TodoItem> = []
        return tempArray
    }()
    
    lazy var toolBar: TodoInputToolBar = {
        let bar = Bundle.main.loadNibNamed("TodoInputToolBar", owner: self, options: nil)![0] as! TodoInputToolBar
        bar.delegate = self
        return bar
    }()
    
    func updateUI() {
        let todos = realm.objects(Todo.self).sorted(byKeyPath: "createdAt", ascending: false)
        viewModel.initData(todoResults: todos)
        self.todoList.reloadData()
    }
    
    func setupAddItemBtn() {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.addTarget(self, action: #selector(addItemAction), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).offset(-12)
            make.bottom.equalTo(self.view).offset(-12)
            make.size.equalTo(60)
        }
    }
    
    @objc func addItemAction() {
        self.toolBar.inputTextfiled.becomeFirstResponder()
    }
    
    func initDB() {
        let todos = realm.objects(Todo.self).sorted(byKeyPath: "createdAt", ascending: false)
        realmNotificationToken = todos.observe { [weak self] (changes: RealmCollectionChange) in
            guard let listView = self?.todoList else { return }
            switch changes {
            case .initial(_):
                listView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                if !insertions.isEmpty {
//                    listView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                }
                if !deletions.isEmpty {
                    listView.reloadData()
                }
                if !modifications.isEmpty {
                    
                    //                        listView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                    //                                                    with: .automatic)
                    // self?.updateUI()
                }
            case .error(let error):
                fatalError("\(error)")
            }
        }
        viewModel.initData(todoResults: todos)
    }
    
}

@available(iOS 11.0, *)
extension TodoListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionModels[section].itemCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cm = viewModel.sectionModels[indexPath.section].cellModels[indexPath.row]
        let cell: TodoItemCell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! TodoItemCell
        cell.cellModel = cm
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completionHandler) in
            completionHandler(true)
        }
        editAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

@available(iOS 11.0, *)
extension TodoListVC: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        print("tableView: canHandle")
        return session.canLoadObjects(ofClass: TodoItem.self)
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        print("tableView: dropSessionDidUpdate")
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("tableView: performDropWith")
        
        var destinationIndexPath: IndexPath?
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        tableView.performBatchUpdates({
            // TODO if !drageIndexPath
            let dragItem: TodoItem = self.dataSource[self.dragIndexPath.row]
            self.dataSource.remove(at: self.dragIndexPath.row)
            self.dataSource.insert(dragItem, at: (destinationIndexPath?.row)!)
            tableView.deleteRows(at: [self.dragIndexPath], with: .fade)
            tableView.insertRows(at: [destinationIndexPath!], with: .fade)
        }) { (finish) in
            
        }
    }
}

@available(iOS 11.0, *)
extension TodoListVC: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("tableView: itemsForBeginning")
        self.dragIndexPath = indexPath;

        return dragItems(forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        print("tableView: itemsForAddingTo")
        return dragItems(forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        print("tableview dragSessionDidEnd")
    }
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        print("tableview dragSessionWillBegin")
    }
    
    func tableView(_ tableView: UITableView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return false
    }
    
    private func dragItems(forRow row: Int) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: self.dataSource[row] as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = self.dataSource[row]
        return [dragItem]
    }
}


@available(iOS 11.0, *)
extension TodoListVC: TodoInputToolBarProtocol {
    func toolBar(_ toolBar: TodoInputToolBar, didSubmit input: InputItem) {
        print(input.content)
        
        let todo = Todo(title: input.content)
        todo.level = input.urgency
        
        try! realm.write() {
            realm.add(todo)
        }
        let cellModel = TodoCellModel.init(todo: todo)
        viewModel.add(cellModel)
        todoList.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
    }
    
    
    @objc func keyboardWillShow(note: Notification) {
    }

    @objc func keyboardWillHide(note: Notification) {
    }
    
    @objc func keyboardWillChangeFrame(note: Notification) {
        let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        let margin = UIScreen.main.bounds.height - y
        if margin > 0 {
            toolBar.snp.updateConstraints({ (make) in
                make.bottom.equalTo(-margin)
            })
        } else {
            toolBar.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view.snp.bottom).offset(100)
            })
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

}

