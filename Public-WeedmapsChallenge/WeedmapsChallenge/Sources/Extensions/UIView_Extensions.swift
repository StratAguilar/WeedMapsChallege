//
//  UIView_Extensions.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

extension UIView {
  func add(subviews: [UIView], useAutoResizing shouldAutoResize: Bool = false) {
    for view in subviews {
      self.addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = shouldAutoResize
    }
  }
}
