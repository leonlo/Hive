//
//  TodoListVC.swift
//  Hive
//
//  Created by Leon Luo on 10/18/17.
//  Copyright © 2017 leonluo. All rights reserved.
//


import Foundation
import UIKit

// MARK: - NextGrowingInternalTextView: UITextView

internal class TodoInputInternalTextView: UITextView {

  // MARK: - Internal

  var didChange: () -> Void = {}
  var didUpdateHeightDependencies: () -> Void = {}

  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)

    NotificationCenter.default.addObserver(self, selector: #selector(TodoInputInternalTextView.textDidChangeNotification(_ :)), name: NSNotification.Name.UITextViewTextDidChange, object: self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override var text: String! {
    didSet {
      didChange()
      updatePlaceholder()
    }
  }
  
  override var attributedText: NSAttributedString! {
    didSet {
      didChange()
      updatePlaceholder()
    }
  }
    
  override var font: UIFont? {
    didSet {
      didUpdateHeightDependencies()
    }
  }
    
  override var textContainerInset: UIEdgeInsets {
    didSet {
      didUpdateHeightDependencies()
    }
  }

  var placeholderAttributedText: NSAttributedString? {
    didSet {
      setNeedsDisplay()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setNeedsDisplay()
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    guard displayPlaceholder else { return }

    let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = textAlignment

    let targetRect = CGRect(
      x: 5 + textContainerInset.left,
      y: textContainerInset.top,
      width: frame.size.width - (textContainerInset.left + textContainerInset.right),
      height: frame.size.height - (textContainerInset.top + textContainerInset.bottom)
    )
    
    let attributedString = placeholderAttributedText
    attributedString?.draw(in: targetRect)
  }

  // MARK: Private

  private var displayPlaceholder: Bool = true {
    didSet {
      if oldValue != displayPlaceholder {
        setNeedsDisplay()
      }
    }
  }

  @objc
  private dynamic func textDidChangeNotification(_ notification: Notification) {
    updatePlaceholder()
    didChange()
  }

  private func updatePlaceholder() {
    displayPlaceholder = text.characters.count == 0
  }
}
