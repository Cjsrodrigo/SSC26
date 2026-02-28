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
    var flashError: Bool = false
    var width: CGFloat? = nil
    
    
    var body: some View {
        HStack(spacing: 50) {
            Text("Challenge")
                .foregroundStyle(.black)
                .font(.system(size: 12, weight: .bold))
            
            BreadcrumbText(
                words: words,
                highlightedCount: highlightedCount,
                flashError: flashError
            )
            
        }
        .frame(width: width)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.90))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
