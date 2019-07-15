//
//  MakeURL.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation


struct MakeURL {
  private let secureProtocol = "https"
  private let domain = "api.yelp.com"
  private let version = "v3"
  
  fileprivate var baseURLString: String {
    return secureProtocol + "://" + domain + "/" + version
  }
}

extension MakeURL {
  struct Suggestion {
    private let makeURL = MakeURL()
    var suggestion: String { return makeURL.baseURLString + "/autocomplete"}
  }
  
  struct Business {
    private let makeURL = MakeURL()
    private let primePath = "businesses"
    var search: String { return makeURL.baseURLString + "/" + primePath + "/search" }
  }
}
