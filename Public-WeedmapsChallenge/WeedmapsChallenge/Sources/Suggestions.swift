//
//  Suggestions.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

import Foundation

// MARK: - Suggestions
struct Suggestions: Codable {
  let categories: [CategorySuggestionItem]?
  let businesses: [BusinessSuggestionItem]?
  let terms: [TermSuggstionItem]?
}

// MARK: - Business
struct BusinessSuggestionItem: Codable {
  let id, name: String?
}

// MARK: - Category
struct CategorySuggestionItem: Codable {
  let alias, title: String?
}

// MARK: - Term
struct TermSuggstionItem: Codable {
  let text: String?
}
