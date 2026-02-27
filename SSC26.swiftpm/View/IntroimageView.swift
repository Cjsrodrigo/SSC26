//
//  IntroimageView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

struct IntroImageView: View {
    let onNext: () -> Void
    @State private var didPlayIntro = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            Image(introAssetName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()

            Button {
                AudioSystem.shared.playSFX("ClickNext")
                onNext()
            } label: {
                Image("NextButton")
            }
        //    .buttonStyle(PressableButtonStyle())
            .padding(28)
            .shadow(radius: 2, y: 4)
        }
        .onAppear {
            guard !didPlayIntro else { return }
            didPlayIntro = true

            // ✅ garante que sessão/players já estão quentes
            AudioSystem.shared.warmUp()
            SpeechService.shared.warmUp()

            // ✅ toca um som ao entrar (MP3/WAV que você tiver no bundle)
            AudioSystem.shared.playSFX("Bell") // <-- troque pelo nome do seu mp3

            // ✅ fala logo em seguida (ajuste o delay conforme o som)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                SpeechService.shared.speak("Recess is over")
            }
        }
    }

    private var introAssetName: String {
        UIDevice.current.userInterfaceIdiom == .phone ? "StoryboardIPhone" : "Storyboard"
    }
}

#if swift(>=5.9)
@available(iOS 17.0, *)
#Preview(traits: .landscapeRight) {
    IntroImageView(onNext: {})
}
#endif
#if swift(>=5.9)
@available(iOS 17.0, *)
#Preview(traits: .landscapeRight) {
    IntroImageView(onNext: {})
}
#endif

