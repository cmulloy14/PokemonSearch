//
//  DefaultsService.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 4/2/25.
//

import Combine
import Foundation

class DefaultsService {
  static let shared = DefaultsService()

  private let defaults = UserDefaults.standard
  private let starredKey = "isItemStarred"

  // Publisher to notify subscribers when value changes
  private let starredSubject = PassthroughSubject<Bool, Never>()
  var starredPublisher: AnyPublisher<Bool, Never> {
    starredSubject.eraseToAnyPublisher()
  }

  // Get the current starred state
  func isStarred() -> Bool {
    return defaults.bool(forKey: starredKey)
  }

  // Update starred state and notify subscribers
  func setStarred(_ isStarred: Bool) {
    defaults.set(isStarred, forKey: starredKey)
    starredSubject.send(isStarred)
  }

  // Toggle starred state and notify subscribers
  func toggleStarred() {
    let newValue = !isStarred()
    setStarred(newValue)
  }

  // For items with unique identifiers
  func isStarred(for id: Int) -> Bool {
    return defaults.bool(forKey: "\(starredKey)_\(id)")
  }

  func setStarred(_ isStarred: Bool, for id: Int) {
    defaults.set(isStarred, forKey: "\(starredKey)_\(id)")
    starredSubject.send(isStarred)
  }
  
  func toggleStarred(for id: Int) {
    let newValue = !isStarred(for: id)
    setStarred(newValue, for: id)
  }
}
