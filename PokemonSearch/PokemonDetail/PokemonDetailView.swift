//
//  PokemonDetailView.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 4/2/25.
//

import SwiftUI

struct PokemonDetailView: View {

  @StateObject var viewModel: PokemonDetailViewModel

  init(viewModel: PokemonDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  init(fromListItem pokemonListItem: PokemonListItem) {
    let viewModel = PokemonDetailViewModel(
      .init(
        pokemonDetailPartial:
          .init(
            pokemonName: pokemonListItem.name,
            pokemonDetailURL: pokemonListItem.url,
            pokemonID: pokemonListItem.id,
            pokemonImageURL: pokemonListItem.imageURL
          )
      )
    )

    self.init(viewModel: viewModel)
  }

  var body: some View {
    VStack {
      if let pokemonID = viewModel.pokemonID {
        HStack {
          Text("\(pokemonID)")
          Text(viewModel.pokemonName)
        }
        CachedImageView(url: viewModel.pokemonImageURL)
        DefaultsConnectedStarButton(itemId: pokemonID)
      } else {
        Spacer()
      }
    }
  }
}

#Preview {
  PokemonDetailView(viewModel:
    PokemonDetailViewModel(
      .init(
        pokemonDetailPartial: .init(
          pokemonName: "Pikachu",
          pokemonDetailURL: URL(string: "https://pokeapi.co/api/v2/pokemon/25/")!,
          pokemonID: 25,
          pokemonImageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")
        )
      )
    )
  )
}
