//
//  NSLayoutDimensions_Extensions.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit


extension NSLayoutDimension {
  
  @discardableResult
  func nail(_ relation: NSLayoutConstraint.Relation = .equal,
            to anchor: NSLayoutDimension,
            with constant: CGFloat = 0.0,
            multiplyBy multiplier: CGFloat = 1.0,
            prioritizeAs priority: UILayoutPriority = .required,
            isActive: Bool = true) -> NSLayoutConstraint {
    
    let constraint: NSLayoutConstraint
    
    switch relation {
    case .equal:
      constraint = self.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
      
    case .greaterThanOrEqual:
      constraint = self.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
      
    case .lessThanOrEqual:
      constraint = self.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
    }
    
    constraint.set(priority: priority, isActive: isActive)
    
    return constraint
  }
  
  @discardableResult
  func nail(_ relation: NSLayoutConstraint.Relation = .equal,
            to constant: CGFloat = 0.0,
            prioritizeAs priority: UILayoutPriority = .required,
            isActive: Bool = true) -> NSLayoutConstraint {
    
    var constraint: NSLayoutConstraint
    
    switch relation {
    case .equal:
      constraint = self.constraint(equalToConstant: constant)
      
    case .greaterThanOrEqual:
      constraint = self.constraint(greaterThanOrEqualToConstant: constant)
      
    case .lessThanOrEqual:
      constraint = self.constraint(lessThanOrEqualToConstant: constant)
    }
    
    constraint.set(priority: priority, isActive: isActive)
    
    return constraint
  }
}

extension UILayoutPriority {
  
  static func +(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
    return UILayoutPriority(lhs.rawValue + rhs)
  }
  
  static func -(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
    return UILayoutPriority(lhs.rawValue - rhs)
  }
}

extension NSLayoutConstraint {
  func set(priority: UILayoutPriority, isActive: Bool) {
    
    self.priority = priority
    self.isActive = isActive
  }
}
