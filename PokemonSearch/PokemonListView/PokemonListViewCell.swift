//
//  PokemonListViewCell.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 4/1/25.
//

import SwiftUI


struct PokemonListViewCell: View {
  var pokemon: Pokemon

  var body: some View {
    HStack {
      CachedImageView(url: pokemon.imageURL, encodedImageString: charizardString)
        .frame(width: 100, height: 100)
      //      AsyncImage(url: pokemon.imageURL) { image in
      //        image.resizable()
      //          .scaledToFit()
      //      } placeholder: {
      //        ProgressView()
      //      }
      Text(pokemon.name)
    }
  }
}


class ImageLoader: ObservableObject {
  @Published var image: UIImage?

  private var cache = NSCache<NSURL, UIImage>()

  func load(from url: URL?) {
    guard let url else { return }
    if let cachedImage = cache.object(forKey: url as NSURL) {
      self.image = cachedImage
      return
    }

    Task {
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        print(data.base64EncodedString())

        if let loadedImage = UIImage(data: data) {
          await MainActor.run { [weak self] in
            self?.cache.setObject(loadedImage, forKey: url as NSURL)
            self?.image = loadedImage
          }
        }
      } catch {
        print("Image loading failed: \(error)")
      }
    }
  }
}


struct CachedImageView: View {
  @StateObject private var loader = ImageLoader()
  let url: URL?
  var encodedImageString: String?

  var encodedImage: UIImage? {
    guard let encodedImageString, let data = Data(base64Encoded: encodedImageString.data(using: .utf8)!) else { return nil }

    return UIImage(data: data)
  }

  var body: some View {
    Group {
      if let image = loader.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
      } else {
        ProgressView()
      }
    }
    .onAppear {
      loader.load(from: url)
    }
  }
}
