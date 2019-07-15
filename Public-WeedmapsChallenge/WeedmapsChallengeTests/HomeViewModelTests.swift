//
//  HomeViewModelTests.swift
//  WeedmapsChallengeTests
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import XCTest
@testable import WeedmapsChallenge

class HomeViewModelTests: XCTestCase {
  
  var homeViewModel: HomeViewModel!
  
  override func setUp() {
    let businessFetchService = MockBusinessFetchService()
    let locationService = MockLocationService()
    homeViewModel = HomeViewModel(requestService: businessFetchService)
    homeViewModel.setup(locationService: locationService)
  }
  
  func testInitialFetch() {
    let fetchExpectation = XCTestExpectation(description: "Waiting for initial Fetch to complete")
    homeViewModel.FetchBusinessList(isNewFetch: true) { (result) in
      switch result {
      case .success(let shouldUpdate):
        XCTAssertEqual(shouldUpdate, true, "Initial Fetch should Always Update")
        fetchExpectation.fulfill()
      case .failure(_):
        XCTFail("Fetch should never fail")
      }
    }
    wait(for: [fetchExpectation], timeout: 10.0)
  }
  
  func testAdditionalFetch() {
    testInitialFetch()
    let fetchExpectation = XCTestExpectation(description: "Waiting for Fetch to complete")
    homeViewModel.FetchBusinessList() { (result) in
      switch result {
      case .success(let shouldUpdate):
        XCTAssertEqual(shouldUpdate, true, "Fetch should Always Update")
        fetchExpectation.fulfill()
      case .failure(_):
        XCTFail("Fetch should never fail")
      }
    }
    wait(for: [fetchExpectation], timeout: 10.0)
  }

}

class HomeViewModelWithData: HomeViewModelTests {
  override func setUp() {
    super.setUp()
    testInitialFetch()
  }
  
  func test_false_endOfList() {
    XCTAssertFalse(homeViewModel.fetchedEndOfList)
  }
  
  func test_equal_businessesCount() {
    XCTAssertEqual(homeViewModel.businessCount, 15)
  }
  
  func test_equal_getBusiness_name() {
    let businessItem = homeViewModel.getBusinssInfo(forIndex: 0)
    XCTAssertEqual(businessItem?.name!, "Molinari Delicatessen")
  }
  
  func test_equal_getBusiness_imageURL() {
    let businessItem = homeViewModel.getBusinssInfo(forIndex: 0)
    XCTAssertEqual(businessItem?.mainImageURL!.absoluteString, "https://s3-media3.fl.yelpcdn.com/bphoto/6He-NlZrAv2mDV-yg6jW3g/o.jpg")
  }
  
  func test_equal_getBusinessPageURL() {
    let pageURL = homeViewModel.getBusinessPageURL(forIndex: 0)
    let checkURLString = "https://www.yelp.com/biz/molinari-delicatessen-san-francisco?adjust_creative=BLBLBQEX5-0zzwEwhYxkXA&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=BLBLBQEX5-0zzwEwhYxkXA"
    XCTAssertEqual(pageURL!.absoluteString, checkURLString)
  }
}
