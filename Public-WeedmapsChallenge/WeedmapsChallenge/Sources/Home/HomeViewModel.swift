//
//  HomeViewModel.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
import CoreLocation

enum FetchRequestError: Error {
  case requestFailure
}

class HomeViewModel {
  
  private let businessRequestService: BusinessRequestServiceProtocol
  private let requestLimit: Int = 15
  private var currentOffset: Int = 0
  private var businessList: BusinessList?
  private var businesses: [Business] {
    return businessList?.businesses ?? []
  }
  
  private(set) var isFetching: Bool = false
  private(set) var hasCompletedInitialLoad: Bool = false
  private var locationService: LocationServiceProtocol? = nil
  
  var searchTerm: String = "restaurant"
  
  var currentCoordiates: Coordiates {
    return locationService?.currentCoordiates ?? LocationService.defaultCoordinates
  }
  
  init(requestService: BusinessRequestServiceProtocol) {
    self.businessRequestService = requestService
  }
  
  func setup(locationService: LocationServiceProtocol) {
    self.locationService = locationService
  }
  
  func FetchBusinessList(isNewFetch: Bool = false, completion: @escaping (Result<Bool, FetchRequestError>) -> Void) {
    guard !isFetching else {
      completion(.success(false))
      return
    }
    isFetching = true
    if isNewFetch {
      businessList = nil
    }
    businessRequestService.getSearchResultsWith(term: searchTerm, coordiates: currentCoordiates, limit: requestLimit, offset: businesses.count) { (result) in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        defer { self.isFetching = false }
        switch result {
        case .success(let value):
          self.hasCompletedInitialLoad = true
          if self.businessList == nil {
            self.businessList = value
          } else {
            let tempBusiness = value.businesses ?? []
            if self.businessList?.total == nil && tempBusiness.count == 0 {
              self.businessList?.total = self.businesses.count
            }
            let newBusinessList = self.businesses + tempBusiness
            self.businessList?.businesses = newBusinessList
          }
          completion(.success(true))
        case .failure(let error): // Todo use this error
          print(error)
          completion(.failure(FetchRequestError.requestFailure))
        }
      }
    }
  }
  
  var fetchedEndOfList: Bool {
    guard let businessList = businessList, let total = businessList.total else { return false }
    return businesses.count >= total
  }
  
  var businessCount: Int {
    return businesses.count
  }
  
  func getBusinssInfo(forIndex index: Int) -> Business? {
    guard index < businesses.count else { return nil }
    return businesses[index]
  }
  
  func getBusinessPageURL(forIndex index: Int) -> URL? {
    guard index < businesses.count, let urlString = businesses[index].url else { return nil }
    return URL(string: urlString)
  }
}
