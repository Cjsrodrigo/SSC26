//
//  Animation test.swift
//  SSC26
//
//  Created by Rodrigo Cont on 19/02/26.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.22, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct HandGuide: View {
    var anchor: CGPoint          // posição alvo (em coordenadas do container)
    var handImageName: String = "Hand"
    var handSize: CGFloat = 45  // ajuste conforme seu asset
    var tapOffset: CGSize = CGSize(width: 25, height: 10) // onde fica a “ponta do dedo” em relação à mão

    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack {
            // Ripple no ponto de toque
//            Ripple()
//                .position(x: anchor.x + tapOffset.width,
//                          y: anchor.y + tapOffset.height)

            // Mão (movimento sutil + micro escala)
            Image(handImageName)
                .resizable()
                .scaledToFit()
                .frame(width: handSize, height: handSize)
                .position(anchor)
                .offset(y: -4 + (phase * 6))                 // “desce e sobe” (sutil)
                .scaleEffect(1.0 - (phase * 0.03))           // “encosta” (sutil)
                .opacity(0.98)
        }
        .allowsHitTesting(false)
        .onAppear {
            // Loop suave
            withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) {
                phase = 1
            }
        }
    }
}

//private struct Ripple: View {
//    @State private var animate = false
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(lineWidth: 2)
//                .scaleEffect(animate ? 1.6 : 0.7)
//                .opacity(animate ? 0.0 : 0.45)
//
//            Circle()
//                .fill(Color.white.opacity(0.18))
//                .scaleEffect(animate ? 1.1 : 0.5)
//                .opacity(animate ? 0.0 : 0.18)
//        }
//        .frame(width: 44, height: 44)
//        .onAppear {
//            // Ripple em loop — clean, sem “pulo”
//            withAnimation(.easeOut(duration: 1.0).repeatForever(autoreverses: false)) {
//                animate = true
//            }
//        }
//    }
//}
