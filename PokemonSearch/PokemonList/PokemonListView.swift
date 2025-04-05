//
//  PokemonListView.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 3/31/25.
//

import SwiftUI

struct PokemonListView: View {
  @StateObject private var viewModel = PokemonListViewModel()

  var body: some View {
    NavigationView {
      List {
        ForEach(viewModel.pokemonList) { pokemon in
          PokemonListViewCell(pokemon: pokemon)
            .onAppear {
              if pokemon == viewModel.pokemonList.last {
                Task {
                  await viewModel.fetchPokemon()
                }
              }
            }
        }

        if viewModel.isLoading {
          ProgressView()
            .frame(maxWidth: .infinity, alignment: .center)
        }
      }
      .navigationTitle("Pokémon List")
      .task {
        await viewModel.fetchPokemon()
      }
    }
  }
}
