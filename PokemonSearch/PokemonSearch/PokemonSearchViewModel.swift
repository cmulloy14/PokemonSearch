//
//  PokemonSearchViewModel.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 4/2/25.
//

import Foundation

@MainActor
final class PokemonSearchViewModel: ObservableObject {
  
  @Published var pokemon: PokemonDetail?
  @Published var searchText = ""

  private let service = PokemonService.shared

  func searchPokemon() {
    Task {
      pokemon = try? await service.pokemonSearch(searchText: searchText)
    }
  }


}
