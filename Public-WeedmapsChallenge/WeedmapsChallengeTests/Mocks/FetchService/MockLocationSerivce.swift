//
//  MockLocationSerivce.swift
//  WeedmapsChallengeTests
//
//  Created by Strat Aguilar on 7/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
@testable import WeedmapsChallenge

struct MockLocationService: LocationServiceProtocol {
  var currentCoordiates: Coordiates {
    return Coordiates(latitude: 11.11, longitude: 11.11)
  }
  
  func getLocation(completion: @escaping ((Result<Coordiates, LocationServiceError>) -> Void)) {
    completion(.success(Coordiates(latitude: 11.11, longitude: 11.11)))
  }
}
