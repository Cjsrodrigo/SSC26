//
//  AppRoute.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

enum AppRoute: Equatable {
    case intro(step: Int)     // 0...N-1
    case introImage           // a tela que você disse que é “uma imagem feita por mim”
    
    case askIntroCard          // ✅ tela do balão (Missão Pedir 1)
    case askAutoModeling       // ✅ tutorial automático (Missão Pedir 2)
    
    case autoPhrase           // (próxima fase) "I want to play more" sozinho
    case freeBoard            // modo livre (final)
}
