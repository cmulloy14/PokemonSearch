//
//  PokemonSearchApp.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 3/31/25.
//

import SwiftUI

@main
struct PokemonSearchApp: App {
  var body: some Scene {
    WindowGroup {
      TabView {
        PokemonListView()
          .tabItem {
            VStack {
              Image("pokeball")
                .renderingMode(.template)
              Text("All Pokemon")
            }
          }
          .tag(0) // Assign a tag for selection tracking
        PokemonSearchView()
          .tabItem {
            Label("Search", systemImage: "magnifyingglass")
          }
          .tag(1)
      }
    }
  }
}
