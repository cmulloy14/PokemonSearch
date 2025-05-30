//
//  PokemonSearchView.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 4/1/25.
//

import SwiftUI

struct PokemonSearchView: View {
  @StateObject private var viewModel = PokemonSearchViewModel()
  @FocusState private var textFieldFocused: Bool

  var body: some View {
    VStack {
      TextField("Search for a Pokemon", text: $viewModel.searchText)
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .onSubmit {
          viewModel.searchPokemon()
        }
        .padding()
        .focused($textFieldFocused)

      if let pokemon = viewModel.pokemon {
        PokemonDetailView(viewModel: .init(
          .init(
            pokemonDetailPartial: .init(
              pokemonName: pokemon.name,
              pokemonDetailURL: pokemon.url,
              pokemonID: pokemon.id,
              pokemonImageURL: pokemon.imageURL
            )
          )
        )
        )
      } else {
        Spacer()
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        textFieldFocused = true
      }
    }
    .padding()
  }
}





let charizardString = "iVBORw0KGgoAAAANSUhEUgAAAGAAAABgBAMAAAAQtmoLAAAALVBMVEUAAAAAAAAIQVIgc5RiYmKDMRjNUkHNzc3mQRDugynutFru3nv2pBD/1RD////8tlCXAAAAAXRSTlMAQObYZgAABLNJREFUWMPtmD1r5EYYx2eOyGypWfAkcsDYc9hwZdYfIl3QBiROgYBl0ARdwGCISRd8nQq72IAG5q5y4SJKHwj7Ba7Z3oVVGPLS+TPkeWak3dXbxttdcVN4kff56fk/r6tdQj6dj/NcbWk/uhpth4yyLNvOxdbA6EO2ZRg32XbE6Pp+cYWqgmeZBxB1WX4AwCn8Z9ij1WhR3htAPgMIAchuSoybpvkpcYJgs58oJ6ObmzLDuD2tgkjrfJgIfEcDsFg8ZNcAcG2POh3Sr/NIJ2RUQggL1ITGQRBq1R+ME+HtTMwPWQlRA8DGQohQ617C2ANAbhZliQCJZmB+cjI5flec9gmaMW4AcAE+EBijPRLFXY+DX+F2HAFI68P9lQVenhgiVd0MabAXhxA0ya7LB9NMS+DkWHUFoQMhvBwnorxvA7pdDCcVS4CMvn9NyFoMqKkdtXNmgcO8qvezAePbsQrWgFd5u+kqQLyyQGJkAlClqRN1KNYBEkofsWHAkUIcfWuA3AKJTxwlloBopQmBMDZQbq+B4EamAYRoRY0hIADdI13rQibhMEBRkYzFkY6Bq1zEUqwBzTTRMwRcEUGYR5KZVomtIhuEEM2oKwAa9gW8hRki1LMOaqAZNQJc7kbwT3hLYhE8UDepNJlXG9taDDxQWrvkhThku1hlBZ1XAQcUXo7dZt0OUxi3GSEvmAeTBEFDzibm1icTQsY9AM7nzKXM7AlmgJfgDf4egIQ24Jx5ZqKnLLWbhWHIk8mxZGMEwEULiO0KyqWsdhHHBB1gOYTfAxCvWlpSWhcaF4YghEs5TvqBN7/l6RqAnYriJRwfg2gCVKtCXaIUOeWWmbExvgMusC4dIJQ6fjKrkdBdQ0R6ZipeuRi3JPFEf/UPRg0LPgFaK3Nh+1ZCP45b25KGSZCqKUx/mMg6VRo/GxzU5JNx3J7RFGXLJEAJNaDzqQGgj/hpe5HBid+a268yBcrcShN3u6tbfZFxAMKlfeDVQEJ2enY9yzIey2QpSCVOCGKsJtpVNCPgIQZRlT0ky6c14HccROAcAHcnTOfzP60HmVBQb4B2jjylzwF4G7rEm89XBK+BpAVQLZlLX+/nPv1xviQsAEGrDkAoI0HydzAj9L0B5sbFboSATlMp3e5nnIxxprm1Ny6mWBvIh1J9QBhKxnwbQuUCP9klTkqvB2Zb4Mv5ygVPPC2ndq66AGQwgPq8XwNmF6lCobpXErQpYWQFoKZE5zw29m96gOk+lDNqADpMphdo3ymcJaAN9AowebrMGdrL26HHJa1WADYtk9isvYrMSXX+ewPQEreALAaAHZixogb+qHocHQwpAkB/V7u4s0AMAzjkwAKF8VEUS+BdcTv4iIhzX1TnLrUdu1cMOrCTvVcBt0uAkU2AjGtAVgDb8JiLbSb3aiA1bcc2PRebrRTvVQAQsrft1obIzO/UEIEp2UAbNQAfBra4C4pnANWWwwcBKMct/3+Aylo0PNYH5krONj7d80aUeJWmm6L+7OIyXNOALpTaBHzz9U8/NwHYSZsA9u/+BXObIZ1vAiij64Wl/Ifwl/PHLb6isafHp78utvlSt+9+/si2AahL3U+/GHyM5z/tOd8zbwTGEwAAAABJRU5ErkJggg=="
