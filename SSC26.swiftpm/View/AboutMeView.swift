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
                    .foregroundStyle(AppColors.textOnLightSurface(scheme))
                    .padding(.horizontal, 12)
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
                Spacer().frame(height: 50)

                Text(language == .ptBR ? "Leia-me" : "Read Me")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(AppColors.textOnLightSurface(scheme))

                // ✅ Card fixo na tela; só o conteúdo interno rola
                VStack {
                    ScrollView {
                        Text(.init(aboutText))
                                .font(.system(size: 18))
                                .foregroundStyle(AppColors.textOnLightSurface(scheme))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 26)
                                .padding(.vertical, 18)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity) // ✅ ocupa o espaço restante da tela
                .background(AppColors.tilefill(scheme).opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(AppColors.stroke(scheme).opacity(0.55), lineWidth: 3)
                )
                .shadow(radius: 2, y: 4)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var markdownAttributed: AttributedString {
        (try? AttributedString(markdown: aboutText)) ?? AttributedString(aboutText)
    }

    private var aboutText: String {
        if language == .ptBR {
            return """
            Eu criei o Expresso para tornar a comunicação mais rápida e divertida.

            Obrigado por experimentar!
            """
        } else {
            return """
            **About me:**

            Hi! My name is Rodrigo, a 26 year old software development student, currently part of the Apple Developer Academy Campinas. I created this project to cause real-world impact using my Swift skills through a fun and educational experience. I hope this brings some awareness to you. Thanks for checking it out!

            **Credits:**

            The pictograms used are property of the government of Aragón and were created by Sergio Palao for [ARASAAC](https://www.arasaac.org), distributed under the Creative Commons License BY-NC-SA.

            The external MP3 sounds are from [ZapSplat](https://www.zapsplat.com/) under the ZapSplat End User License Agreement (EULA).
            """
        }
    }
}
