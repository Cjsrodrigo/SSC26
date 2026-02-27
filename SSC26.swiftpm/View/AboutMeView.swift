//
//  AboutMeView.swift
//  Expresso
//
//  Created by Rodrigo Cont on 23/02/26.
//

import SwiftUI

struct AboutMeView: View {
    
    let onBack: () -> Void
    @Environment(\.colorScheme) private var scheme

    @AppStorage("expresso.lang") private var langRaw: String = AppLanguage.en.rawValue
    private var language: AppLanguage { AppLanguage(rawValue: langRaw) ?? .en }

    var body: some View {
        ZStack(alignment: .topLeading) {
            AppColors.background(scheme).ignoresSafeArea()

            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColors.textOnLightSurface(scheme))                      .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(AppColors.tilefill(scheme).opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.12), lineWidth: 1.5)
                    )
            }
            .padding(.leading, 18)
            .padding(.top, 14)

            VStack(spacing: 16) {
                Spacer().frame(height: 70)

                Text(language == .ptBR ? "Leia-me" : "Read Me")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(AppColors.textOnLightSurface(scheme))
                ScrollView {
                    Text(aboutText)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(AppColors.textOnLightSurface(scheme))                    .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)
                        .padding(.vertical, 18)
                        .background(AppColors.tilefill(scheme).opacity(0.9))                         .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AppColors.stroke(scheme).opacity(0.55), lineWidth: 3)
                        )
                        .shadow(radius: 2, y: 4)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var aboutText: String {
        if language == .ptBR {
            return "Eu criei o Expresso para tornar a comunicação mais rápida e divertida.\nObrigado por experimentar!"
        } else {
            return "I built Expresso to make communication faster and fun. loremipson....."
        }
    }
}
