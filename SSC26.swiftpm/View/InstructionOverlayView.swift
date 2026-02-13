//
//  InstructionOverlayView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI

struct InstructionOverlayView: View {
    let sceneTitle: String
    let text: String
    let onNext: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // Board por trás, escurecido e sem interação
            BoardView()
                .allowsHitTesting(false)
                .overlay(Color.black.opacity(0.45))

            // título no topo esquerdo
            VStack {
                HStack {
                    Text(sceneTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.85))
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)

                Spacer()
            }

            // Card central
            VStack(alignment: .center) {
                Text(text)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .frame(width: 600, height: 135, alignment: .leading)
                    .padding(.horizontal, 26)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.90))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .shadow(radius: 2, y: 4)
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            Button(action: onNext) {
                Image("NextButton")
               
            }
        }
        .ignoresSafeArea()
    }
}
