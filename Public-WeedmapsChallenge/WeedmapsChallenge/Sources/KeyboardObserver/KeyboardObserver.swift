//
//  KeyboardObserver.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

@objc protocol KeyboardObserver {
  @objc func keyboardWillShow(_ notification: Notification)
  @objc func keyboardDidShow(_ notification: Notification)
  @objc func keyboardWillHide(_ notification: Notification)
}

extension KeyboardObserver {
  func setupKeyboardObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                           name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                           name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)),
                                           name: UIResponder.keyboardDidShowNotification, object: nil)
  }
  
  func destroyKeyboardObservers() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    
  }
}
