//
//  TodoStrikeThroughLabel.swift
//  Hive
//
//  Created by Leon Luo on 11/17/17.
//  Copyright © 2017 leonluo. All rights reserved.
//

import UIKit

class TodoStrikeThroughLabel: UILabel {
    
    fileprivate let strikeThroughColorAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.strikethroughColor: UIColor.gray]

    
    var isMarked: Bool! {
        didSet {
            if isMarked {
                self.setMarkedAttributes(to: mutabelAttributedText)
            } else {
                self.setUnMarkedAttributes(to: mutabelAttributedText)
            }
        }
    }
    var currentProgress: CGFloat!
    
    let markedAttribute:  [NSAttributedStringKey : Any] =
        [.strikethroughColor: UIColor.gray]
    let unMarkedAttribute:  [NSAttributedStringKey : Any] =
        [.strikethroughStyle: UIColor.black]
    
    
    var mutabelAttributedText: NSMutableAttributedString!
    
    var content: String!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("can not initialize by this way.")
    }
    
    init(frame: CGRect, content text: String, isMarked: Bool) {
        super.init(frame: frame)
        self.content = text
        self.mutabelAttributedText = NSMutableAttributedString.init(string: text, attributes: strikeThroughColorAttribute)
        self.attributedText = self.mutabelAttributedText
        self.isMarked = isMarked
        
    }
    
    func update(_ content: String, isMarked: Bool) {
        self.content = content
        self.mutabelAttributedText = NSMutableAttributedString.init(string: content, attributes: strikeThroughColorAttribute)
        self.isMarked = isMarked
        
    }
    
    func drawLine(_ isDraw: Bool, animated: Bool ) {
        if isDraw {
            if animated {
//                var index: Int = 0
//                
//                
//                let timer = DispatchSource.makeTimerSource()
//                timer.schedule(deadline: DispatchTime.now(), repeating: 10, leeway: .milliseconds(10))
//                timer.setEventHandler(handler: {
//                    DispatchQueue.main.async {
//                        self.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, ((self.attributedText?.length)! / 20 * index)), to: self.mutabelAttributedText)
//                        self.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, ((self.attributedText?.length)! / 20 * index)), to: self.mutabelAttributedText)
//                        
//                        index = index + 1
//
//                    }
//                    
//                })
//                
                

                    
            
                
                    self.setMarkedAttributes(to: self.mutabelAttributedText)
                    self.isMarked = true
                
            } else {
                self.setMarkedAttributes(to: self.mutabelAttributedText)
                self.isMarked = true

            }
        } else {
            self.isMarked = false
            self.setUnMarkedAttributes(to: self.mutabelAttributedText)
            
        }
    }
    
    
    convenience init(_ text: String, isMarked: Bool) {
        self.init(frame: CGRect.zero, content: text, isMarked: isMarked)
        
    }
    
    
    
}

extension TodoStrikeThroughLabel: TodoItemCellProtocol {

    func cell(didBeganSpanning cell: TodoItemCell) {
        currentProgress = 0.0
    }
    
    func cell(_ todoItemCell: TodoItemCell, didSpanningIn progress: CGFloat) {
        currentProgress = progress
        
        let nsContent = self.content! as NSString
        let maxRange = nsContent.range(of: content)
        let currentLength = CGFloat.init(maxRange.length) * progress
        
        if !isMarked {
            self.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, Int.init(ceil(currentLength))), to: mutabelAttributedText)
        } else {
            self.removeAttribute(NSAttributedStringKey.strikethroughStyle, range: maxRange, to: mutabelAttributedText)
            self.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(Int.init(ceil(currentLength)), Int.init(ceil(Double(maxRange.length))) - Int.init(ceil(currentLength))), to: mutabelAttributedText)
        }
    
    }
    
    func cell(didEndedSpanning cell: TodoItemCell) -> Bool {
        if currentProgress == nil || currentProgress == 0 {
            return isMarked
        }
        if !isMarked {
            if currentProgress > 0.4 {
//                self.setMarkedAttributes(to: mutabelAttributedText)
                self.isMarked = true
                return true
            } else{
                self.isMarked = false
//                self.setUnMarkedAttributes(to: mutabelAttributedText)
                return false
            }
            
        } else {
            
            if currentProgress > 0.5 {
                self.isMarked = false
//                self.setUnMarkedAttributes(to: mutabelAttributedText)
                return false
            } else {
//                self.setMarkedAttributes(to: mutabelAttributedText)
                self.isMarked = true
                return true
            }
            
        }
        
    }
    
    
    fileprivate func setMarkedAttributes(to attributeString: NSMutableAttributedString) {
        self.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length), to: attributeString)
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributeString.length), to: attributeString)
    }
    
    fileprivate func setUnMarkedAttributes(to attributeString: NSMutableAttributedString) {
        self.removeAttribute(NSAttributedStringKey.strikethroughStyle, range: NSMakeRange(0, attributeString.length), to: attributeString)
        self.removeAttribute(NSAttributedStringKey.foregroundColor, range: NSMakeRange(0, attributeString.length), to: attributeString)

    }
    
    
    fileprivate func addAttribute(_ name: NSAttributedStringKey, value: Any, range: NSRange, to: NSMutableAttributedString) {
        to.addAttribute(name, value: value, range: range)
        self.attributedText = to
    }
    
    fileprivate func removeAttribute(_ name: NSAttributedStringKey, range: NSRange, to: NSMutableAttributedString) {

        to.removeAttribute(name, range: range)
        self.attributedText = to
    }

}


