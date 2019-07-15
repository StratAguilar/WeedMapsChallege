//
//  BusinessRequestService.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
import Alamofire

struct Coordiates {
  let latitude: Double
  let longitude: Double
}

extension Coordiates: Equatable {}

enum RequestError: Error {
  case dataDecodingError
}

protocol BusinessRequestServiceProtocol {
  func getSearchResultsWith(term: String, coordiates: Coordiates, limit: Int, offset: Int, completion: @escaping ((Result<BusinessList>) -> Void)) 
}

struct BussinessApiRequest: BusinessRequestServiceProtocol {
  
  let configurationService: APIConfigurationService
  
  init(config: APIConfigurationService){
    self.configurationService = config
  }
  
  let businessURL = MakeURL.Business()
  
  func getSearchResultsWith(term: String, coordiates: Coordiates, limit: Int = 15, offset: Int = 0, completion: @escaping ((Result<BusinessList>) -> Void)) {
    
    let params: [String: Any] = [
      "term": term,
      "latitude": coordiates.latitude,
      "longitude": coordiates.longitude,
      "limit": limit,
      "offset": offset
    ]
    
    let headers = configurationService.headers
    
    let url = businessURL.search
    print("Featch \(url) with parms: \(params)")
    Alamofire.request(url, method: .get, parameters: params, headers: headers)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseData { (response) in
        print(response.description)
        
        switch response.result {
        case .success(let data):
          do {
            let list =  try JSONDecoder().decode(BusinessList.self, from: data)
            completion(.success(list))
          } catch (let error) {
            completion(.failure(error))
          }
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
}
