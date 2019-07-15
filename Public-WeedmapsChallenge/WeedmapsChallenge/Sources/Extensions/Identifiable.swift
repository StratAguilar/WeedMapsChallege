//
//  Identifiable.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

protocol Identifiable: class { }

extension Identifiable {
  static var identifier: String {
    get {
      return String(describing: self)
    }
  }
}
