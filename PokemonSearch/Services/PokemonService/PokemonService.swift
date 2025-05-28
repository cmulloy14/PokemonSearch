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
  let next: URL?
  let previous: String?
  let results: [PokemonListItem]
}

struct PokemonListItem: Decodable, Identifiable, Equatable, Hashable {

  let name: String
  let url: URL
  private var pokemonID: Int?

  init(name: String, url: URL) {
    self.name = name
    self.url = url
  }


  var imageURL: URL? {
    guard let id else { return nil }
    return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
  }

  var id: Int? {
    if let pokemonID { return pokemonID }
    let pattern = #"/pokemon/(\d+)/"#
    let urlString = url.absoluteString
    if let regex = try? NSRegularExpression(pattern: pattern),
       let match = regex.firstMatch(in: urlString, range: NSRange(urlString.startIndex..., in: urlString)),
       let range = Range(match.range(at: 1), in: urlString) {
      return Int(urlString[range])
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
    self.url = try container.decode(URL.self, forKey: .url)
    self.pokemonID = try container.decodeIfPresent(Int.self, forKey: .pokemonID)
  }

}

// MARK: - Network Service
final class PokemonService: PokemonServiceProtocol {
  static let shared = PokemonService()
  private init() {}
  private let baseURL = URL(string:"https://pokeapi.co/api/v2/pokemon")!

  func fetchPokemonList(from url: URL?) async throws -> PokemonListResponse {
    let url = url ?? baseURL
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(PokemonListResponse.self, from: data)
  }

  func fetchPokemonList(
  from url: URL?,
  completion: @escaping (Result<PokemonListResponse, Error>) -> Void) {
    Task {
      do {
        let response = try await fetchPokemonList(from: url)
        completion(.success(response))
      } catch {
        completion(.failure(error))
      }
    }
  }

  func pokemonSearch(searchText: String) async throws -> PokemonDetail {
    guard let url = URL(string: "\(baseURL)/\(searchText)") else {
      throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(PokemonDetail.self, from: data)
  }

  func getPokemonDetail(url: URL) async throws -> PokemonDetail {
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(PokemonDetail.self, from: data)
  }
}

