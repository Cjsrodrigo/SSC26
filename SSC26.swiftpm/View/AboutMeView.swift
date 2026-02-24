//
//  AboutMeView.swift
//  Expresso
//
//  Created by Rodrigo Cont on 23/02/26.
//

import SwiftUI

struct AboutMeView: View {
    let onBack: () -> Void

    @AppStorage("expresso.lang") private var langRaw: String = AppLanguage.en.rawValue
    private var language: AppLanguage { AppLanguage(rawValue: langRaw) ?? .en }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(hex: "#8CCED7").ignoresSafeArea()

            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.leading, 18)
            .padding(.top, 14)

            VStack(spacing: 16) {
                Spacer().frame(height: 70)

                Text(language == .ptBR ? "Sobre mim" : "About me")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(.black)

                Text(aboutText)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 18)
                    .background(Color.white.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2, y: 3)

                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var aboutText: String {
        if language == .ptBR {
            return "Eu criei o Expresso para tornar a comunicação mais rápida e divertida.\nObrigado por experimentar!"
        } else {
            return "I built Expresso to make communication faster and fun.\nThanks for trying it!"
        }
    }
}
