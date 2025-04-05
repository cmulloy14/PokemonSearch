//
//  Theme.swift
//  PokemonSearch
//
//  Created by Pat Mulloy on 4/5/25.
//

import SwiftUI

// Define a theme
struct AppTheme {
    let primaryColor: Color
    let secondaryColor: Color
    let neutralColor: Color
    let headerFont: Font
    let bodyFont: Font
    let captionFont: Font

    static let defaultTheme = AppTheme(
        primaryColor: .blue,
        secondaryColor: .gray,
        neutralColor: .black,
        headerFont: .system(.title, design: .rounded, weight: .bold),
        bodyFont: .system(.body),
        captionFont: .system(.caption)
    )

    static let darkTheme = AppTheme(
        primaryColor: .teal,
        secondaryColor: .gray,
        neutralColor: .white,
        headerFont: .system(.title, design: .rounded, weight: .bold),
        bodyFont: .system(.body),
        captionFont: .system(.caption)
    )
}

// Environment key for theme
struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .defaultTheme
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
