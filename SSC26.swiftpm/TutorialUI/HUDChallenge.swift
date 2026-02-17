//
//  HUDChallenge.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//


import SwiftUI

struct ChallengeHUD: View {
    let title: String
    let words: [String]
    let highlightedCount: Int
    var flashError: Bool = false   // ✅ novo

    var body: some View {
        HStack(spacing: 60) {
            Text("Challenge")
                .foregroundStyle(.black)
                .font(.system(size: 12, weight: .semibold))

            VStack(spacing: 3) {
                Text(title)
                    .foregroundStyle(.black)

                    .font(.system(size: 12, weight: .semibold))

                BreadcrumbText(
                    words: words,
                    highlightedCount: highlightedCount,
                    flashError: flashError
                )
            }
        }
        .frame(width: 296)
        .padding(3)
        .background(Color.white.opacity(0.90))
        .clipShape(RoundedRectangle(cornerRadius: 8))
//        .overlay(
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(flashError ? Color.red : Color.black.opacity(0.25), lineWidth: 1)
//        )
    }
}

