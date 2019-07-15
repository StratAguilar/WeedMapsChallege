//
//  MockBusinessRequestService.swift
//  WeedmapsChallengeTests
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
@testable import WeedmapsChallenge
import Alamofire

class MockBusinessFetchService: BusinessRequestServiceProtocol {
  func getSearchResultsWith(term: String, coordiates: Coordiates, limit: Int, offset: Int, completion: @escaping ((Result<BusinessList>) -> Void)) {
    if offset == 0 {
      let testBundle = Bundle(for: type(of: self))
      let path = testBundle.url(forResource: "BusinessesData", withExtension: "json")!
      let jsonData = (try? Data(contentsOf: path, options: .mappedIfSafe))!
      let object = try? JSONDecoder().decode(BusinessList.self, from: jsonData)
      completion(Result.success(object!))
    } else {
      let testBundle = Bundle(for: type(of: self))
      let path = testBundle.url(forResource: "BusinessesPage2Data", withExtension: "json")!
      let jsonData = (try? Data(contentsOf: path, options: .mappedIfSafe))!
      let object = try? JSONDecoder().decode(BusinessList.self, from: jsonData)
      completion(Result.success(object!))
    }
  }
  
  
}
