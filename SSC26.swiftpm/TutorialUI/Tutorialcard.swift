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
    var textAlignment: TextAlignment = .leading   // ✅ novo

    var maxWidth: CGFloat = 650
    var minWidth: CGFloat = 350
    var height: CGFloat = 125
    var topPadding: CGFloat = 25
    var horizontalPadding: CGFloat = 16

    // Ajuste fino: deixa o card um pouco mais “respirado”
    var verticalPadding: CGFloat = 8

    private var font: UIFont { .systemFont(ofSize: 17, weight: .regular) }

    private var idealWidth: CGFloat {
        // largura máxima disponível pro TEXTO (sem padding)
        let maxTextWidth = maxWidth - (horizontalPadding * 2)

        // mede com quebra de linha (multiline)
        let rect = (text as NSString).boundingRect(
            with: CGSize(width: maxTextWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )

        // width real do conteúdo + padding
        let contentW = ceil(rect.width) + (horizontalPadding * 2)

        // clamp entre min e max
        return min(maxWidth, max(minWidth, contentW))
    }
    
    private var frameAlignment: Alignment {
        textAlignment == .center ? .center : .leading
    }

    var body: some View {
        Text(.init(text))
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(.black)
            .multilineTextAlignment(textAlignment)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: frameAlignment)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(width: idealWidth, alignment: frameAlignment)
            .frame(minHeight: height, alignment: frameAlignment)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.90))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .shadow(radius: 2, y: 4)
            )
            .padding(.top, topPadding)
            .animation(.easeInOut(duration: 0.25), value: text)
    }
}
