//
//  PokemonDetail.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 5/27/25.
//

import Foundation

struct PokemonDetail: Decodable, Identifiable, Equatable {

  init(name: String, url: String?) {
    self.name = name
    self.url = url
  }


  let name: String
  var url: String?
  private var pokemonID: Int?

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
