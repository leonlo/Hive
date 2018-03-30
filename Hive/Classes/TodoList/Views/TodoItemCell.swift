//
//  TodoItemCell.swift
//  Hive
//
//  Created by Leon Luo on 10/19/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit
import SnapKit

class TodoItemCell: UITableViewCell {
    
    private var _panBeganX: CGFloat!
    private var _panEndedX: CGFloat!
    private var _panBeganY: CGFloat!
    private var _spanShouldAffactUI: Bool! = false
    private var isMarked: Bool!
    
    typealias MarkStatusDidChangedHandler = (Bool, TodoCellModel) -> ()

    var markStatusDidChanged: MarkStatusDidChangedHandler!
    var todoCellDelegate: TodoItemCellProtocol!
    
    
    
    var cellModel: TodoCellModel? {
        
        didSet {
            guard let cm = cellModel else { return }
            self.contentView.addSubview(self.contentLabel)
            self.todoCellDelegate = self.contentLabel
            self.contentLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.contentView).offset(12)
                make.right.lessThanOrEqualTo(self.contentView).offset(-12)
                make.top.equalTo(self.contentView).offset(10)
                make.bottom.equalTo(self.contentView).offset(-10)
            }
            self.isMarked = cm.status == .resolved
            self.contentLabel.update(cm.title, isMarked: cm.status == .resolved)

        }
    }
    
    lazy var contentLabel: TodoStrikeThroughLabel! = {
        let isMarked = cellModel?.status == .resolved ? true : false
        let label = TodoStrikeThroughLabel((cellModel?.title)!, isMarked: isMarked)
        label.numberOfLines = 0
        return label
    } ()
    
    lazy var photoImageView: UIImageView! = {
        let imageView = UIImageView()
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var descLabel: UILabel! = {
        let label = UILabel.init()
        self.contentView.addSubview(label)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(TodoItemCell.handlePan(gestureRecognizer:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        if gestureRecognizer.state == .began {
            // didBeganSpanning direction
            _panBeganX = translation.x
            _panBeganY = translation.y
            _spanShouldAffactUI = false
            self.todoCellDelegate?.cell(didBeganSpanning: self)
        }
        
        if gestureRecognizer.state == .changed {
            if translation.x - _panBeganX < 10  {
                return
            }
            if fabsf(Float(translation.y - _panBeganY)) > fabsf(Float(translation.x - _panBeganX)) {
                return
            }
            let horizontalDistance = translation.x - _panBeganX
            if translation.x < 0 {
                return
            }
            let width = self.contentLabel.frame.size.width + 10
            if horizontalDistance < 0 || horizontalDistance > width {
                return
            }
            self.todoCellDelegate?.cell(self, didSpanningIn: (horizontalDistance / width))
            _spanShouldAffactUI = true
        }
        
        if gestureRecognizer.state == .ended {
            // cellDidEndedSpanning direction
            if _spanShouldAffactUI {
                guard let cm = self.cellModel else { return }
                guard let isMarked = self.todoCellDelegate?.cell(didEndedSpanning: self) else {
                    return
                }
                let isPreviousMarked = cellModel?.status == .resolved ? true : false
                if isPreviousMarked != isMarked {
                    if isMarked {
                        cm.status = .resolved
                    } else {
                        cm.status = .pending
                    }
                    self.markStatusDidChanged(isMarked, cm)
                }
            }
        }
    }    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func drawLine(_ isDraw: Bool, animated: Bool ) {
        self.contentLabel.drawLine(isDraw, animated: animated)
    }
    
}
