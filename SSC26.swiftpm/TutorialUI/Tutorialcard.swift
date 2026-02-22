//
//  Tutorialcard.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI
import UIKit

struct TutorialCard: View {
    let text: String

    var maxWidth: CGFloat = 650
    var minWidth: CGFloat = 350
    var height: CGFloat = 125
    var topPadding: CGFloat = 25
    var horizontalPadding: CGFloat = 16

    // Ajuste fino: deixa o card um pouco mais “respirado”
    var verticalPadding: CGFloat = 8

    private var font: UIFont { .systemFont(ofSize: 17, weight: .regular) }

    private var idealWidth: CGFloat {
        // mede o texto como uma única linha
        let raw = (text as NSString).size(withAttributes: [.font: font]).width

        // soma padding e um “respiro” extra
        let w = raw + (horizontalPadding * 2) + 24

        // clamp entre min e max
        return min(maxWidth, max(minWidth, w))
    }

    var body: some View {
        Text(text)
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(.black)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true) // ✅ permite quebrar linha e crescer em altura
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(width: idealWidth, alignment: .leading) // ✅ aqui fica responsivo até maxWidth
            .frame(minHeight: height, alignment: .leading) // ✅ mantém “altura base” (72/125 etc.)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.90))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .shadow(radius: 2, y: 4)
            )
        .padding(.top, topPadding)
        
            .animation(.easeInOut(duration: 0.25), value: text)

    }
}
