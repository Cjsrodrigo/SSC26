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
    var width: CGFloat? = nil


    var body: some View {
        HStack(spacing: 50) {
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
        .frame(width: width)                 // ✅ sem fallback fixo aqui
        .padding(.vertical, 3)
        .background(Color.white.opacity(0.90))
        .clipShape(RoundedRectangle(cornerRadius: 8))
//        .overlay(
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(flashError ? Color.red : Color.black.opacity(0.25), lineWidth: 1)
//        )
    }
}

#if swift(>=5.9)
@available(iOS 17.0, *)
#Preview("ChallengeHUD - Default") {
    ChallengeHUD(
        title: "Sort the words",
        words: ["let", "x", "=", "10"],
        highlightedCount: 2,
        flashError: false,
        width: 296
    )
    .padding()
    .background(Color.gray.opacity(0.2))
}

@available(iOS 17.0, *)
#Preview("ChallengeHUD - Error Flash") {
    ChallengeHUD(
        title: "Arrange the tiles",
        words: ["print", "(", "x", ")"],
        highlightedCount: 3,
        flashError: true,
        width: 320
    )
    .padding()
    .background(Color.gray.opacity(0.2))
}
#endif

