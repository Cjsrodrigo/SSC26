//
//  ExperienceSettings.swift
//  Expresso
//
//  Created by Rodrigo Cont on 23/02/26.
//

import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case en
    case ptBR

    var id: String { rawValue }
}

enum ColorBlindMode: String, CaseIterable, Identifiable {
    case off
    case protanopia
    case deuteranopia
    case tritanopia

    var id: String { rawValue }
}

enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
