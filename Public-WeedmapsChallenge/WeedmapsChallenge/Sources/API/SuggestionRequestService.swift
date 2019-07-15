//
//  SuggestionRequestService.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
import Alamofire

protocol SuggestionRequestServiceProtocol {
  func getSearchSuggestion(term: String, coordiates: Coordiates, completion: @escaping ((Result<Suggestions>) -> Void))
}

struct SuggestionRequestService: SuggestionRequestServiceProtocol {
  let configurationService: APIConfigurationService
  
  let suggestionsURL = MakeURL.Suggestion()
  
  func getSearchSuggestion(term: String, coordiates: Coordiates, completion: @escaping ((Result<Suggestions>) -> Void)){
    let params: [String: Any] = [
      "text": term,
      "latitude": coordiates.latitude,
      "longitude": coordiates.longitude
    ]
    let headers = configurationService.headers
    let url = suggestionsURL.suggestion
    print("Featch \(url) with parms: \(params)")
    Alamofire.request(url, method: .get, parameters: params, headers: headers)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseData { (response) in
        print(response.description)
        
        switch response.result {
        case .success(let data):
          do {
            let list =  try JSONDecoder().decode(Suggestions.self, from: data)
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
