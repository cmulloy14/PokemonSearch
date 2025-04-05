//
//  PokemonListView.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 3/31/25.
//

import SwiftUI

struct PokemonListView: View {
  @StateObject private var viewModel = PokemonListViewModel()

  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(viewModel.pokemonList.indices, id: \.self) { index in
            let pokemon = viewModel.pokemonList[index]

            VStack(spacing: 0) {
              PokemonListViewCell(pokemon: pokemon)
                .onAppear {
                  if pokemon == viewModel.pokemonList.last {
                    Task {
                      await viewModel.fetchPokemon()
                    }
                  }
                }

              if index != viewModel.pokemonList.count - 1 {
                Divider()
                //.padding(.leading, 60) // to offset for the Pokémon image
                  .background(Color.white.opacity(0.8)) // or your desired color
              }
            }
          }
          if viewModel.isLoading {
            ProgressView()
              .padding()
          }
        }
        .padding(.top)
      }

      .navigationTitle("Pokémon List")
      .task {
        await viewModel.fetchPokemon()
      }
    }
  }
}
