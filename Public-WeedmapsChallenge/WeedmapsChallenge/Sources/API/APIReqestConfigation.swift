//
//  ApiReqestConfigation.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation


struct APIRequestConfiguration: APIConfigurationService {
  let token = "8RpxksCqcvS0HoVbqLW6PsVG6UwhdH3HSngRlx67PP4WPRzMcEEMZ1sF36dLKTF3Il4xyYw36Cf2evq6WYC-1ATn-bzlrbHjvzrx5MDwGKqhEaplp4en5eiYfg0qXXYx"
  
  var headers: [String: String] {
    let tempHeader: [String: String] = ["Authorization": "Bearer \(token)"]
    return tempHeader
  }
}

protocol APIConfigurationService {
  var headers: [String: String] { get }
}
