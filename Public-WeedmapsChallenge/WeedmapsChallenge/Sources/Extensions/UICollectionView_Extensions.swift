//
//  UICollectionView_Extensions.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

@nonobjc extension UICollectionView {
  
  func registerCell<T: UICollectionViewCell>(_ cellType: T.Type) {
    register(T.self, forCellWithReuseIdentifier: T.identifier)
  }
  
  func dequeueReusableCell<T: Identifiable>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
    let cell = dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath)
    return cell as! T
  }
}

extension UICollectionViewCell: Identifiable {

}
