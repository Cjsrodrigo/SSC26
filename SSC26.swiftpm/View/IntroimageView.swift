//
//  IntroimageView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

struct IntroImageView: View {
    let onNext: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black.opacity(0.85).ignoresSafeArea()

            // Troque "YourIntroImage" pelo nome do seu asset
            Image("Storyboard")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
              //  .ignoresSafeArea()

            Button {
                AudioSystem.shared.playSFX("ApplePCClick")
                onNext()
            } label: {
                Image("NextButton")
            }
            .buttonStyle(PressableButtonStyle())

            .padding(21)
        }
    }
}
