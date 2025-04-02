//
//  PokemonListViewModel.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 3/31/25.
//

import Foundation

@MainActor
final class PokemonViewModel: ObservableObject {
    @Published var pokemonList: [Pokemon] = []
    @Published var nextPageURL: String? = "https://pokeapi.co/api/v2/pokemon"
    @Published var isLoading = false

    private let service = PokemonService.shared

    func fetchPokemon() async {
        guard let url = nextPageURL, !isLoading else { return }
        isLoading = true

        do {
            let response = try await service.fetchPokemonList(from: url)
            pokemonList.append(contentsOf: response.results)
            nextPageURL = response.next
        } catch {
            print("Error fetching Pokémon: \(error)")
        }

        isLoading = false
    }
}
