//
//  PokemonDetailViewModel.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 5/28/25.
//

import Foundation

@MainActor
final class PokemonDetailViewModel: ObservableObject {

  var pokemonName: String {
    deps.pokemonDetailPartial.pokemonName
  }

  var pokemonID: Int? {
    deps.pokemonDetailPartial.pokemonID
  }

  var pokemonImageURL: URL? {
    deps.pokemonDetailPartial.pokemonImageURL
  }

  struct PokemonDetailPartial {
    let pokemonName: String
    let pokemonDetailURL: URL
    let pokemonID: Int?
    let pokemonImageURL: URL?
  }

  struct Deps {
    let pokemonDetailPartial: PokemonDetailPartial
  }

  
  private let deps: Deps

  init(_ deps: Deps) {
    self.deps = deps
  }

}
