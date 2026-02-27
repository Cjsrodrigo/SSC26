//
//  MainMenu.swift
//  Expresso
//
//  Created by Rodrigo Cont on 23/02/26.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var flow: AppFlowViewModel
    
    @Environment(\.colorScheme) private var scheme

    // ✅ preferências persistidas
    @AppStorage("expresso.lang") private var langRaw: String = AppLanguage.en.rawValue
    @AppStorage("expresso.colorBlindMode") private var cbRaw: String = ColorBlindMode.off.rawValue
    @AppStorage("expresso.appearance") private var appearanceRaw: String = AppAppearance.light.rawValue

    private var languageValue: AppLanguage { AppLanguage(rawValue: langRaw) ?? .en }
    private var appearanceValue: AppAppearance { AppAppearance(rawValue: appearanceRaw) ?? .system }

    private var isUnlocked: Bool { flow.canShowUnlockedButtons }

    // ✅ bindings diretos no AppStorage
    private var languageBinding: Binding<AppLanguage> {
        Binding(
            get: { AppLanguage(rawValue: langRaw) ?? .en },
            set: { langRaw = $0.rawValue }
        )
    }

    private var colorBlindBinding: Binding<ColorBlindMode> {
        Binding(
            get: { ColorBlindMode(rawValue: cbRaw) ?? .off },
            set: { cbRaw = $0.rawValue }
        )
    }

    private var appearanceBinding: Binding<AppAppearance> {
        Binding(
            get: { AppAppearance(rawValue: appearanceRaw) ?? .system },
            set: { appearanceRaw = $0.rawValue }
        )
    }

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            // Topbar fixa
            let topBarHeight: CGFloat = 56
            let contentHeight = max(0, h - topBarHeight)

            // Responsivo
            let isPhoneCompact = (h <= 430)

            let iconSize = clamp(contentHeight * 0.30, min: isPhoneCompact ? 70 : 86, max: isPhoneCompact ? 108 : 120)
            let titleFont = clamp(contentHeight * 0.13, min: isPhoneCompact ? 20 : 28, max: isPhoneCompact ? 33 : 42)

            let buttonHeight = clamp(contentHeight * 0.125, min: isPhoneCompact ? 44 : 50, max: isPhoneCompact ? 54 : 62)
            let buttonWidth  = clamp(w * 0.38, min: isPhoneCompact ? 240 : 280, max: isPhoneCompact ? 330 : 380)

            // ✅ reduz espaço entre ícone e título (pedido)
//            let iconTitleGap = clamp(contentHeight * 0.012, min: 4, max: 10)

            // espaços gerais
            let topPadding = clamp(contentHeight * 0.05, min: isPhoneCompact ? 10 : 14, max: 24)
            let titleButtonsGap = clamp(contentHeight * 0.02, min: 8, max: 14)
            let buttonsSpacing = clamp(contentHeight * 0.02, min: 8, max: 12)

            ZStack(alignment: .top) {
                AppColors.background(scheme).ignoresSafeArea()

                VStack(spacing: 0) {
                    // espaço inicial pra “subir” tudo e não ficar centralizando para baixo
                    VStack(spacing: clamp(contentHeight * 0.01, min: 0, max: 6)) {
                        AppMark(iconSize: iconSize)

                        Text("Welcome to Expresso")
                            .font(.system(size: titleFont, weight: .bold))
                            .foregroundStyle(AppColors.textOnLightSurface(scheme))                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .padding(.top, topPadding)

                    .padding(.bottom, titleButtonsGap)

                    // ✅ UM ÚNICO VStack COM OS 3 BOTÕES (slots fixos)
                    VStack(spacing: buttonsSpacing) {
                        PrimaryMenuButton(
                            title: t("Start experience"),
                            width: buttonWidth,
                            height: buttonHeight
                        ) {
                            flow.startExperience()
                        }

                        PrimaryMenuButton(
                            title: t("Free mode"),
                            width: buttonWidth,
                            height: buttonHeight
                        ) {
                            flow.goFreeMode()
                        }
                        .opacity(isUnlocked ? 1 : 0)                 // ✅ ocupa espaço, mas some
                        .allowsHitTesting(isUnlocked)                // ✅ não clica se bloqueado

                        PrimaryMenuButton(
                            title: t("About me"),
                            width: buttonWidth,
                            height: buttonHeight
                        ) {
                            flow.goAboutMe()
                        }
                        .opacity(isUnlocked ? 1 : 0)
                        .allowsHitTesting(isUnlocked)
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
                .frame(height: contentHeight)
                .padding(.horizontal, 18)
                .padding(.top, topBarHeight)

            //     ✅ Topbar fixa
                topBar
                    .frame(height: topBarHeight)
                    .padding(.horizontal, 18)
                    .padding(.top, 10)
           }
        }
        .preferredColorScheme(appearanceValue.colorScheme)
    }

    private var topBar: some View {
        HStack(spacing: 10) {
            
            Spacer()
//            
//            Menu {
//                Picker("Color Blind Mode", selection: colorBlindBinding) {
//                    Text("Off").tag(ColorBlindMode.off)
//                    Text("Protanopia").tag(ColorBlindMode.protanopia)
//                    Text("Deuteranopia").tag(ColorBlindMode.deuteranopia)
//                    Text("Tritanopia").tag(ColorBlindMode.tritanopia)
//                }
//            } label: {
//                TopIconButtonLabel(systemName: "eye.trianglebadge.exclamationmark")
//            }
//
//     
//
//            Menu {
//                Picker("Language", selection: languageBinding) {
//                    Text("English").tag(AppLanguage.en)
//                    Text("Português (Brasil)").tag(AppLanguage.ptBR)
//                }
//            } label: {
//                TopIconButtonLabel(systemName: "globe")
//            }

            Menu {
                Picker("Appearance", selection: appearanceBinding) {
                    Text("System").tag(AppAppearance.system)
                    Text("Light").tag(AppAppearance.light)
                    Text("Dark").tag(AppAppearance.dark)
                }
            } label: {
                TopIconButtonLabel(systemName: "circle.righthalf.filled")
            }
        }
    }

    private func t(_ key: String) -> String {
        switch languageValue {
        case .en:
            return key
        case .ptBR:
            switch key {
            case "Welcome to Expresso": return "Bem-vindo a Expresso"
            case "Start experience": return "Iniciar experiência"
            case "Free mode": return "Modo livre"
            case "About me": return "Sobre mim"
            default: return key
            }
        }
    }

    private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        Swift.max(min, Swift.min(max, value))
    }
}

// MARK: - Components

private struct AppMark: View {
    let iconSize: CGFloat

    var body: some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.white.opacity(0.75))
//                .frame(width: iconSize, height: iconSize)
////                .overlay(
////                    RoundedRectangle(cornerRadius: 20)
////                        .stroke(Color.black.opacity(0.15), lineWidth: 2)
//                //)

            // ✅ se não aparecer, crie um Image Set separado, ex: "MainMenuIcon"
            Image("MainMenuIcon")
                .resizable()
                .scaledToFit()
                .padding(iconSize * 0.16)
//                .clipShape(RoundedRectangle(cornerRadius: 180, style: .continuous))
        }
        .shadow(radius: 3, y: 4)
    }
}

private struct PrimaryMenuButton: View {
    let title: String
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    @Environment(\.colorScheme) private var scheme

    
    private var fontSize: CGFloat {
        max(16, min(22, height * 0.40))
    }

    var body: some View {
        
        Button(action: action) {            
            Text(title)
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundStyle(AppColors.textOnLightSurface(scheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .frame(width: width, height: height)
                .background(AppColors.tilefill(scheme).opacity(0.9))                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(AppColors.stroke(scheme).opacity(0.55), lineWidth: 3)
                )
                .shadow(radius: 2, y: 4)
        }
        .buttonStyle(.plain)
    }
}

private struct TopIconButtonLabel: View {
    let systemName: String
    
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(AppColors.textOnLightSurface(scheme))            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(AppColors.tilefill(scheme).opacity(0.75))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.12), lineWidth: 1.5)
            )
    }
}

#if swift(>=5.9)
@available(iOS 17.0, *)
#Preview(traits: .landscapeRight) {
    MainMenuView(flow: AppFlowViewModel())
}
#endif
