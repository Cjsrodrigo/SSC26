//
//  IntroOverlayView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

struct IntroOverlayView: View {
    let text: String
    let onNext: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // Fundo: seu board por trás, escurecido e sem interação
            BoardView()
                .allowsHitTesting(false)
                .overlay(Color.black.opacity(0.9))

            // Card branco central
            VStack(alignment: .center) {
                Text(text)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .frame(width: 600, height: 135, alignment: .leading)
                    .padding(.horizontal, 26)
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

            // Botão next (canto inferior direito)
            Button(action: onNext) {
                Image("NextButton")
               
            }
            .padding(28)
            .shadow(radius: 2, y: 4)
        }
        .ignoresSafeArea()
    }
}

#if canImport(SwiftUI)
import SwiftUI
#endif
#if swift(>=5.9)
@available(iOS 17.0, *)
#Preview(traits: .landscapeRight) {
    IntroOverlayView(text: "PODD is a type of augmentative and alternative communication that helps people communicate using organized vocabulary, promoting autonomy through functional and broad language to everyone who needs support to express themselves.", onNext: {})
}
#endif

// Fallback preview for earlier iOS versions or toolchains without the #Preview macro
#if !compiler(>=5.9) || !canImport(SwiftUI)
// No preview support
#else
#if !os(watchOS)
struct IntroOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
#endif
#endif




