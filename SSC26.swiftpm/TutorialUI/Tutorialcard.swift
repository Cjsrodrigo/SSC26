//
//  Tutorialcard.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI

struct TutorialCard: View {
    let text: String

    var width: CGFloat = 600
    var height: CGFloat = 125
    var topPadding: CGFloat = 25
    var horizontalPadding: CGFloat = 26

    var body: some View {
        ZStack {
            Text(text)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
                .frame(width: width, height: height, alignment: .leading)
                .padding(.horizontal, horizontalPadding)
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
        .padding(.top, topPadding)
    }
}
