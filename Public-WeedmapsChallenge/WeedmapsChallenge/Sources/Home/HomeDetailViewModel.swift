//
//  HomePageDetailViewModel.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

class HomeDetailViewModel {
  
  private let pageURL: URL
  
  var urlRequest: URLRequest {
    return URLRequest(url: pageURL)
  }
  
  init(url: URL) {
    self.pageURL = url
  }
  
}
