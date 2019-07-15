//
//  SearchViewModel.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

enum SearchSection {
  case suggestion
  case history
}

class SearchViewModel {
  
  private let suggestionsRequestService: SuggestionRequestServiceProtocol
  private let sections: [SearchSection] = [.suggestion, .history]
  private let searchHistoryCache: SearchHistoryCacheProtocol
  private var model: Suggestions? = nil
  var currentSearchTerm: String? = nil
  var suggestions: [String] {
    return model?.businesses?.compactMap{ $0.name } ?? []
  }
  var historyItem: [String] {
    return searchHistoryCache.searchList
  }
  
  private let locationService: LocationServiceProtocol
  
  init(suggestionsRequestService: SuggestionRequestServiceProtocol,
       locationService: LocationServiceProtocol,
       searchHistoryCacheService: SearchHistoryCacheProtocol) {
    self.suggestionsRequestService = suggestionsRequestService
    self.locationService = locationService
    self.searchHistoryCache = searchHistoryCacheService
  }
  
  var numberOfSections: Int { return sections.count }
  
  func numberOfRows(forSection section: SearchSection) -> Int {
    switch section {
    case .suggestion: return suggestions.count
    case .history: return historyItem.count
    }
  }
  
  func getSection(forIndex index: Int) -> SearchSection? {
    guard index < sections.count else { return nil }
    return sections[index]
  }
  
  func getTitle(forSection section: SearchSection) -> String? {
    switch section {
    case .history:
      guard historyItem.count > 0 else { return nil }
      return "History"
    case .suggestion:
      guard suggestions.count > 0 else { return nil }
      return "Suggestions"
    }
  }
  
  func getTitle(forSection section: SearchSection, withIndex index: Int) -> String? {
    switch  section {
    case .history:
      guard index <  historyItem.count else { return nil }
      return historyItem[index]
    case .suggestion:
      guard index < suggestions.count else { return nil }
      return suggestions[index]
    }
  }
  
  func fetchSuggestion(withSearchTerm searchTerm: String, completion: @escaping ((Result<Bool, FetchRequestError>) -> Void)) {
    guard !searchTerm.isEmpty else {
      model = nil
      completion(.success(true))
      return
    }
    let coordiates = locationService.currentCoordiates
    suggestionsRequestService.getSearchSuggestion(term: searchTerm, coordiates: coordiates) { (result) in
      switch result {
      case .success(let value):
        self.model = value
        completion(.success(true))
      case .failure(_):
        completion(.failure(FetchRequestError.requestFailure))
      }
    }
  }
  
  func fetchLocation(completion: @escaping ((Result<Bool, LocationServiceError>) -> Void)) {
    locationService.getLocation() { result in
      switch result {
      case .success(let newCoordiates):
        print(newCoordiates)
        completion(.success(true))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func add(historyText: String) {
    searchHistoryCache.add(item: historyText)
  }
  
  func addCurrentHistoryText() {
    guard let currentHistoryText = currentSearchTerm else { return }
    add(historyText: currentHistoryText)
  }
  
  func saveHistory() {
    searchHistoryCache.save()
  }
}
