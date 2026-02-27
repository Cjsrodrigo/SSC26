//
//  SpotlightTutorialScene.swift
//  SSC26
//
//  Created by Rodrigo Cont on 15/02/26.
//
import SwiftUI

struct SpotlightTutorialConfig {
    let pageId: Int
    let text: String
    let dimOpacity: Double
    let holes: [GuidedTarget]
    let stroke: GuidedTarget?
}

struct SpotlightTutorialScene: View {
    let cfg: SpotlightTutorialConfig
    let onNext: () -> Void

    @StateObject private var board = BoardViewModel(pages: BoardDefinition.makePages())

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BoardSpotlightOverlay(
                board: board,
                pageId: cfg.pageId,
                mode: .targets(holes: cfg.holes, stroke: cfg.stroke),
                text: cfg.text,
                dimOpacity: cfg.dimOpacity,
                  cardMaxWidth: 600,
                  cardMinWidth: 120,
                  cardHeight: 125,
                cardTopPadding: 20,
                cardY: nil// ajuste se quiser
            )            


            Button {
                AudioSystem.shared.playSFX("ClickNext")
                onNext()
            } label: {
                Image("NextButton")
            }
         //   .buttonStyle(PressableButtonStyle())

                .padding(28)
                .shadow(radius: 2, y: 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .ignoresSafeArea()
    }
}
