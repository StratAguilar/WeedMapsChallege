//
//  SearchHistoryCache.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation


protocol SearchHistoryCacheProtocol {
  var searchList: [String] { get }
  func add(item: String)
  func save()
}

class SearchHistoryCache: SearchHistoryCacheProtocol {
  private let cacheStore = UserDefaults.standard
  private let max: Int = 10
  private let key = "SearchHistory"
  private var list: [String] = []
  private var listSet: Set<String> = []
  
  init() {
    list = (cacheStore.array(forKey: key) as? [String]) ?? []
    for item in list {
      listSet.insert(item)
    }
  }
  
  var searchList: [String] {
    return list
  }
  
  func save() {
    cacheStore.set(list, forKey: key)
  }
  
  func add(item: String) {
    if listSet.contains(item), let index = list.index(of: item) {
      list.remove(at: index)
      list.insert(item, at: 0)
    } else {
      list.insert(item, at: 0)
      listSet.insert(item)
      
      if list.count > max {
        let lastValue = list.removeLast()
        listSet.remove(lastValue)
      }
    }
  }
}

