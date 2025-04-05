//
//  StarButton.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 4/2/25.
//

import Combine
import SwiftUI


// MARK: - DefaultsConnectedStarButton

struct DefaultsConnectedStarButton: View {
  @StateObject private var viewModel: StarButtonViewModel

  let size: CGFloat
  var filledColor: Color
  var unfilledColor: Color

  // Initialize with optional itemId for specific items
  init(itemId: Int, size: CGFloat = 24, filledColor: Color = .yellow, unfilledColor: Color = .gray) {
    _viewModel = StateObject(wrappedValue: StarButtonViewModel(itemId: itemId))
    self.size = size
    self.filledColor = filledColor
    self.unfilledColor = unfilledColor
  }

  var body: some View {
    StarButton(
      isStarred: $viewModel.isStarred,
      size: size,
      filledColor: filledColor,
      unfilledColor: unfilledColor,
      action: {
        viewModel.toggleStarred()
      }
    )
  }
}

struct StarButton: View {
  @Binding var isStarred: Bool
  var size: CGFloat = 24
  var filledColor: Color = .yellow
  var unfilledColor: Color = .gray
  var action: (() -> Void)? = nil

  // Animation properties
  @State private var animationAmount: CGFloat = 1

  var body: some View {
    Button(action: {
      withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
        isStarred.toggle()
        animationAmount = 1.5

        // Call the custom action if provided
        action?()

        // Reset the animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          withAnimation {
            animationAmount = 1.0
          }
        }
      }
    }) {
      Image(systemName: isStarred ? "star.fill" : "star")
        .resizable()
        .scaledToFit()
        .frame(width: size, height: size)
        .foregroundColor(isStarred ? filledColor : unfilledColor)
    }
    .scaleEffect(animationAmount)
    .buttonStyle(PlainButtonStyle())
    .contentShape(Rectangle()) // Makes the entire area tappable
  }
}

// MARK: - StarButtonViewModel
class StarButtonViewModel: ObservableObject {
  @Published var isStarred: Bool
  private let defaultsService = DefaultsService.shared
  private let itemId: Int
  private var cancellables = Set<AnyCancellable>()

  init(itemId: Int) {
    self.itemId = itemId

    // Initialize with current value
    self.isStarred = defaultsService.isStarred(for: itemId)

    // Listen for changes from other parts of the app
    defaultsService.starredPublisher
      .sink { [weak self] _ in
        self?.refreshFromDefaults()
      }
      .store(in: &cancellables)
  }

  func toggleStarred() {
    defaultsService.toggleStarred(for: itemId)
    refreshFromDefaults()
  }

  private func refreshFromDefaults() {
    isStarred = defaultsService.isStarred(for: itemId)
  }
}

// Previews
struct StarButton_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 50) {
      StarButton(isStarred: .constant(true), size: 30)
        .previewDisplayName("Starred")

      StarButton(isStarred: .constant(false), size: 30)
        .previewDisplayName("Not Starred")

      // Different color scheme
      StarButton(
        isStarred: .constant(true),
        size: 40,
        filledColor: .red,
        unfilledColor: .gray.opacity(0.3)
      )
      .previewDisplayName("Custom Colors")
    }
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
