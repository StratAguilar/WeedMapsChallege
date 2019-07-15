//
//  NSLayoutAnchor_Extensions.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

@objc extension NSLayoutAnchor {
  
  @discardableResult
  func nail(_ relation: NSLayoutConstraint.Relation,
            to anchor: NSLayoutAnchor,
            with constant: CGFloat,
            prioritizeAs priority: UILayoutPriority = .required,
            isActive: Bool = true) -> NSLayoutConstraint {
    
    var constraint: NSLayoutConstraint
    
    switch relation {
    case .equal:
      constraint = self.constraint(equalTo: anchor, constant: constant)
      
    case .greaterThanOrEqual:
      constraint = self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
      
    case .lessThanOrEqual:
      constraint = self.constraint(lessThanOrEqualTo: anchor, constant: constant)
    }
    constraint.set(priority: priority, isActive: isActive)
    
    return constraint
  }
}
