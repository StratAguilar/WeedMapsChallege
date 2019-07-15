//
//  MockAPIConfigurationService.swift
//  WeedmapsChallengeTests
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
@testable import WeedmapsChallenge

struct MockAPIConfigurationService: APIConfigurationService  {
  var headers: [String : String] { return [:] }
}
