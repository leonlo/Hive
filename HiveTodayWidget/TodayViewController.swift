//
//  TodayViewController.swift
//  HiveTodayWidget
//
//  Created by Leon Luo on 10/10/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        self.view.addSubview(self.tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
//        public convenience init(item view1: Any, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation, toItem view2: Any?, attribute attr2: NSLayoutAttribute, multiplier: CGFloat, constant c: CGFloat)

        let leftConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        self.view.addConstraints([leftConstraint, rightConstraint, widthConstraint, heightConstraint])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    lazy var tableView: UITableView = {
        let t = UITableView(frame: CGRect.zero, style: .plain)
        t.delegate = self
        t.dataSource = self
        return t
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "text"
        cell.detailTextLabel?.text = "detail"
        return cell
    }
    
    
    func updateLayout() {
    }
}


extension TodayViewController: NCWidgetProviding {
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .compact) {
            self.preferredContentSize = maxSize;
        }
        else {
            self.preferredContentSize = CGSize.init(width: 0, height: 200);
        }
    }
}

