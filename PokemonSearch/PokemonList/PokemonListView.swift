//
//  PokemonListView.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 3/31/25.
//

import SwiftUI

struct PokemonListView: View {

  enum ViewMode {
    case list
    case grid
  }

  @StateObject private var viewModel = PokemonListViewModel()
  @State private var viewMode: ViewMode = .list

  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  var body: some View {
    NavigationStack(path: $viewModel.navigationPath) {
      ZStack {
        if viewModel.showError {
          Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(.red)
        }
        VStack(spacing: 0) {
          ScrollView {
            if viewMode == .list {
              LazyVStack(spacing: 4) {
                createList()
              }
              .padding(.top)
            } else {
              LazyVGrid(columns: columns, spacing: 16) {
                createList()
              }
              .padding(.top)
            }
          }
          .animation(.easeInOut, value: viewMode)
        }
      }
      .navigationTitle("Pokémon List")
      .navigationDestination(for: PokemonListViewModel.NavigationDestination.self) { destination in
        switch destination {
        case let .detailView(listItem):
          PokemonDetailView(fromListItem: listItem)
        }
      }
      .toolbar {
        Picker("View Mode", selection: $viewMode) {
          Label("List", systemImage: "list.bullet").tag(ViewMode.list)
          Label("Grid", systemImage: "square.grid.2x2").tag(ViewMode.grid)
        }
        .padding()
      }
      .task {
        await viewModel.fetchPokemon()
      }

    }
    .alert("Something went wrong", isPresented: $viewModel.showErrorAlert) {
      Button("OK", role: .cancel) { }
    }
  }

  @ViewBuilder
  private func createList() -> some View {
    ForEach(viewModel.pokemonList.indices, id: \.self) { index in
      let pokemon = viewModel.pokemonList[index]
      createCell(pokemon: pokemon, viewMode: viewMode)
    }
    if viewModel.isLoading {
      ProgressView()
        .padding()
    }
  }

  private func createCell(pokemon: PokemonListItem, viewMode: ViewMode) -> some View {
    PokemonListViewCell(pokemon: pokemon, viewMode: viewMode)
      .onAppear {
        if pokemon == viewModel.pokemonList.last {
          Task {
            await viewModel.fetchPokemon()
          }
        }
      }
      .onTapGesture {
        viewModel.didTapListItem(pokemon)
      }
  }
}
