//
//  BookTile.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//

import SwiftUI

enum Actionkind: Equatable {
    case backToPage1
    case openYesNoBoard
}

enum TileKind: Equatable {
    case word
    case action(Actionkind)
}

struct BookTile: Identifiable, Equatable {
    let id = UUID()

    let label: String
    let appendText: String?     
    let speakText: String

    let iconName: String
    let borderColor: Color
    let kind: TileKind
}
