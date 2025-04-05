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
      Spacer()
      CachedImageView(url: pokemon.imageURL, encodedImageString: charizardString)
        .frame(width: 100, height: 100)
      Text(pokemon.name)
        .font(.title2)
      Spacer()

    }
    .background(Color.gray.opacity(0.1))
  }
}


class ImageLoader: ObservableObject {
  @Published var image: UIImage?

  func load(from url: URL?) {
    guard let url else { return }

    Task {
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let loadedImage = UIImage(data: data) {
          await MainActor.run { [weak self] in
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

  init(url: URL?, encodedImageString: String? = nil) {
    print("NEW CACHED IMAGE VIEW CREATED FOR :\(url!.absoluteString)")
    self.url = url
    self.encodedImageString = encodedImageString
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
