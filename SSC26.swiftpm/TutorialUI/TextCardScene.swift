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

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            BoardView()
                .allowsHitTesting(false)
                .overlay(Color.black.opacity(dimOpacity))


            TutorialCard(text: text)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            Button(action: onNext) { Image("NextButton") }
                .padding(28)
                .shadow(radius: 2, y: 4)
        }
        .ignoresSafeArea()
    }
}
