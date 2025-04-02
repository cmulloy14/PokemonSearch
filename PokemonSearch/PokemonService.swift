//
//  PokemonService.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 3/31/25.
//

import Foundation

// MARK: - Models
struct PokemonListResponse: Decodable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [Pokemon]
}

struct Pokemon: Decodable, Identifiable, Equatable {
  let name: String
  var url: String?
  var pokemonID: Int?

  var imageURL: URL? {
    guard let id else { return nil }
    return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
  }

  var id: Int? {
    if let pokemonID { return pokemonID }
    guard let url else { return nil }
    let pattern = #"/pokemon/(\d+)/"#
    if let regex = try? NSRegularExpression(pattern: pattern),
       let match = regex.firstMatch(in: url, range: NSRange(url.startIndex..., in: url)),
       let range = Range(match.range(at: 1), in: url) {
      return Int(url[range])
    }
    return nil
  }

  enum CodingKeys: String, CodingKey {
    case name
    case url
    case pokemonID = "id"
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.url = try container.decodeIfPresent(String.self, forKey: .url)
    self.pokemonID = try container.decodeIfPresent(Int.self, forKey: .pokemonID)
  }

}

// MARK: - Network Service
class PokemonService {
  static let shared = PokemonService()
  private let baseURL = "https://pokeapi.co/api/v2/pokemon"

  func fetchPokemonList(from url: String? = nil) async throws -> PokemonListResponse {
    let urlString = url ?? baseURL
    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }

    let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(PokemonListResponse.self, from: data)
  }

  func pokemonSearch(searchText: String) async throws -> Pokemon {
    guard let url = URL(string: "\(baseURL)/\(searchText)") else {
      throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(Pokemon.self, from: data)
  }


}

