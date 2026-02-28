//
//  BoardView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//

import SwiftUI

struct BoardView: View {
    @StateObject private var vm = BoardViewModel(pages: BoardDefinition.makePages())
    @State private var didWarmUp = false
    
    
    var body: some View {
        BoardViewContent(vm: vm)
        
            .onAppear {
                guard !didWarmUp else { return }
                didWarmUp = true
                
                AudioSystem.shared.warmUp()
                SpeechService.shared.warmUp()
            }
        
    }
}

