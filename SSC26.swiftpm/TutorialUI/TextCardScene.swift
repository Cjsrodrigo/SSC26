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
                AudioSystem.shared.playSFX("ApplePCClick")
                onNext()
            } label: {
                Image("NextButton")
            }
       //     .buttonStyle(PressableButtonStyle())

            .padding(28)
            .shadow(radius: 2, y: 4)
            
//            GeometryReader { geo in
//                    // exemplo: apontar para o botão Next (canto inferior direito)
//                    let p = CGPoint(x: geo.size.width - 70, y: geo.size.height - 70)
//                    HandGuide(anchor: p, handImageName: "Hand", handSize: 45)
//                }
        }
        .ignoresSafeArea()
    }
}
