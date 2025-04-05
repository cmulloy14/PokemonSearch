//
//  LabelStyles.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 4/5/25.
//

import SwiftUI

// Define reusable modifiers
struct HeaderLabelStyle: ViewModifier {
  @Environment(\.appTheme) var theme
  
  func body(content: Content) -> some View {
    content
      .font(.title)
      .fontWeight(.bold)
      .lineLimit(2)
      .minimumScaleFactor(0.8)
  }
}

struct BodyLabelStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.body)
      .lineSpacing(5)
  }
}

// Add convenience extensions to Text
extension Text {
  func headerStyle() -> some View {
    self.modifier(HeaderLabelStyle())
  }

  func bodyStyle() -> some View {
    self.modifier(BodyLabelStyle())
  }
}
