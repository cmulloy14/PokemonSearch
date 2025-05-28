//
//  PokemonDetail.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 5/27/25.
//

import Foundation

struct PokemonDetail: Identifiable, Equatable {

  init(name: String, url: URL) {
    self.name = name
    self.url = url
  }


  let name: String
  let url: URL
  private var pokemonID: Int?

  var imageURL: URL? {
    guard let id else { return nil }
    return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
  }

  var id: Int? {
    if let pokemonID { return pokemonID }
    let urlString = url.absoluteString
    let pattern = #"/pokemon/(\d+)/"#
    if let regex = try? NSRegularExpression(pattern: pattern),
       let match = regex.firstMatch(in: urlString, range: NSRange(urlString.startIndex..., in: urlString)),
       let range = Range(match.range(at: 1), in: urlString) {
      return Int(urlString[range])
    }
    return nil
  }
}

extension PokemonDetail: Decodable {

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
