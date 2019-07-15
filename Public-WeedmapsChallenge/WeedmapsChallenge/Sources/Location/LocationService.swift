//
//  LocationService.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
  var currentCoordiates: Coordiates { get }
  func getLocation(completion: @escaping ((Result<Coordiates, LocationServiceError>) -> Void))
}

enum LocationServiceError: Error {
  case requestError
}

class LocationService: NSObject, LocationServiceProtocol {
  
  static let defaultCoordinates = Coordiates(latitude: 33.91571, longitude: -117.901)
  let locationManager = CLLocationManager()
  var updateLocationClosure: ((Result<Coordiates, LocationServiceError>) -> Void)? = nil
  private(set) var currentCoordiates: Coordiates = LocationService.defaultCoordinates
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func checkForAuthorization() -> Bool {
    
    let isLocationEnabled = CLLocationManager.locationServicesEnabled()
    let isPermissionGranted = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    
    guard isLocationEnabled else {
      return false
    }
    
    guard isPermissionGranted else {
      locationManager.requestWhenInUseAuthorization()
      return false
    }
    
    return true
  }
  
  func getLocation(completion: @escaping ((Result<Coordiates, LocationServiceError>) -> Void)) {
    if checkForAuthorization() {
      locationManager.requestLocation()
      self.updateLocationClosure = completion
    }
  }
  
}

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else { return }
    let newCoordiates = Coordiates(latitude: firstLocation.coordinate.latitude, longitude: firstLocation.coordinate.longitude)
    self.currentCoordiates = newCoordiates
    updateLocationClosure?(.success(newCoordiates))
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    updateLocationClosure?(.failure(LocationServiceError.requestError))
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      locationManager.requestLocation()
    }
  }
}
