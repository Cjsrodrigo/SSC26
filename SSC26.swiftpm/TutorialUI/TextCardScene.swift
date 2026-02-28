//
//  TextCardScene.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI

struct TextCardScene: View {
    let text: String
    let dimOpacity: Double
    let onNext: () -> Void
    
    var textAlignment: TextAlignment = .leading
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            BoardView()
                .allowsHitTesting(false)
                .overlay(Color.black.opacity(dimOpacity))
            
            
            TutorialCard(text: text, textAlignment: textAlignment) // ✅ aqui
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            Button {
                AudioSystem.shared.playSFX("ClickNext")
                onNext()
            } label: {
                Image("NextButton")
            }
            .padding(28)
            .shadow(radius: 2, y: 4)
        }
        .ignoresSafeArea()
    }
}
