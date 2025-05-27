//
//  PokemonListViewModel.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 3/31/25.
//

import Foundation

protocol PokemonServiceProtocol {
  func fetchPokemonList(from url: URL?) async throws -> PokemonListResponse
  func fetchPokemonList(
    from url: URL?,
    completion: @escaping (Result<PokemonListResponse, Error>) -> Void
  )
  func getPokemonDetail(url: URL) async throws -> PokemonDetail
}

@MainActor
final class PokemonListViewModel: ObservableObject {
  @Published var pokemonList: [PokemonListItem] = []
  @Published var nextPageURL = URL(string:"https://pokeapi.co/api/v2/pokemon")
  @Published var isLoading = false
  @Published var showError = false
  @Published var showErrorAlert = false
  @Published var searchText = ""

  private let service: PokemonServiceProtocol

  init(service: PokemonServiceProtocol = PokemonService.shared) {
    self.service = service
  }

  func fetchPokemon() async {
    guard let url = nextPageURL, !isLoading else { return }
    isLoading = true


    do {
      try await Task.sleep(nanoseconds: 1_000_000_000)
      let response = try await service.fetchPokemonList(from: url)
      pokemonList.append(contentsOf: response.results)
      nextPageURL = response.next
    } catch {
      print("Error fetching Pokémon: \(error)")
    }
    isLoading = false
  }

  func fetchPokemonCompletion() {
    guard let url = nextPageURL, !isLoading else { return }
    isLoading = true
    service.fetchPokemonList(from: url, completion: { [weak self] result in
      switch result {
      case let .success(response):
        DispatchQueue.main.async {
          self?.pokemonList.append(contentsOf: response.results)
          self?.nextPageURL = response.next
          self?.isLoading = false
        }
      case .failure:
        print("Error fetching Pokémon")
        self?.isLoading = false
      }
    })

  }
}
