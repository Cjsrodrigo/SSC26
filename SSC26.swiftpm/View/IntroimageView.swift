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
                .scaledToFit()
                .padding(24)

            Button(action: onNext) {
                Image("NextButton")
               
            }
            .padding(21)
        }
    }
}
