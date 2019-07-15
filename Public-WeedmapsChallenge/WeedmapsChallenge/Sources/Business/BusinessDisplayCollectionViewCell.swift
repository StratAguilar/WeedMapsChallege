//
//  BusinessDisplayCollectionViewCell.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

class BusinessDisplayCollectionViewCell: UICollectionViewCell {
  
  static let suggestedHeight: CGFloat = 220
  static let suggestedWidth: CGFloat = 160
  static let suggestedSize: CGSize = CGSize(width: suggestedWidth, height: suggestedHeight)
  
  let mainImageView = UIImageView()
  let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraints()
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    contentView.add(subviews: [mainImageView, titleLabel])
    mainImageView.heightAnchor.nail(.equal, to: mainImageView.widthAnchor, with: 0)
    mainImageView.leadingAnchor.nail(.equal, to: contentView.leadingAnchor, with: WMStyle.Constant.padLight)
    mainImageView.trailingAnchor.nail(.equal, to: contentView.trailingAnchor, with: -WMStyle.Constant.padLight)
    mainImageView.topAnchor.nail(.equal, to: contentView.topAnchor, with: WMStyle.Constant.padLight)
    mainImageView.centerXAnchor.nail(.equal, to: contentView.centerXAnchor, with: 0)
    
    titleLabel.leadingAnchor.nail(.equal, to: contentView.leadingAnchor, with: WMStyle.Constant.padLight)
    titleLabel.topAnchor.nail(.equal, to: mainImageView.bottomAnchor, with: WMStyle.Constant.padLight)
    titleLabel.trailingAnchor.nail(.equal, to: contentView.trailingAnchor, with: -WMStyle.Constant.padLight)
    titleLabel.bottomAnchor.nail(.lessThanOrEqual, to: contentView.bottomAnchor, with: -WMStyle.Constant.padLight)
    
  }
  
  private func setupView() {
    contentView.layer.cornerRadius = 4
    contentView.clipsToBounds = true
    
    mainImageView.layer.cornerRadius = 4
    mainImageView.clipsToBounds = true
    
    titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 3
    
    self.isAccessibilityElement = true
    self.accessibilityIdentifier = "BusinessCell"
    mainImageView.isAccessibilityElement = true
    mainImageView.accessibilityIdentifier = "CellMainImageView"
    titleLabel.isAccessibilityElement = true
    titleLabel.accessibilityIdentifier = "CellTitle"
  }
  
  func setup(title: String?, imageURL: URL?, imageFetchService: ImageCacheFetchService) {
    titleLabel.text = title
    imageFetchService.getImage(fromURL: imageURL, imageView: mainImageView)
  }
  
  func setup(object: BusinessDisplayCVCellProtocol, imageFetchService: ImageCacheFetchService) {
    setup(title: object.title, imageURL: object.mainImageURL, imageFetchService: imageFetchService)
  }
  
}

protocol BusinessDisplayCVCellProtocol {
  var title: String? { get }
  var mainImageURL: URL? { get }
}

extension Business: BusinessDisplayCVCellProtocol {
  var title: String? {
    return name
  }
  
  var mainImageURL: URL? {
    guard let URLString = imageURL else { return nil }
    return URL(string: URLString)
  }
}


