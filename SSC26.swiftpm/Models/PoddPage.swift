//
//  BookPage.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//

import SwiftUI

struct BookPage: Identifiable, Equatable {
    
    let id: Int
    let title: String
    let tabColor: Color
    let tiles: [BookTile]
}
