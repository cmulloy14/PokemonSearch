//
//  PokemonSearchDetailView.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 4/2/25.
//

import SwiftUI

struct PokemonSearchDetailView: View {

  let pokemon: Pokemon

  var body: some View {
    VStack {
      if let pokemonID = pokemon.id {
        HStack {
          Text("\(pokemonID)")
          Text(pokemon.name)
        }
        CachedImageView(url: pokemon.imageURL)
        DefaultsConnectedStarButton(itemId: pokemonID)
      } else {
        Spacer()
      }
    }
  }
}

#Preview {
  PokemonSearchDetailView(pokemon: .init(name: "Pikachu", url: ""))
}
