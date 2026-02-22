//
//  TutorialPAgesScene.swift
//  SSC26
//
//  Created by Rodrigo Cont on 18/02/26.
//

import SwiftUI

struct TutorialPagesStepConfig {
    let sceneTitle: String
    let pageId: Int
    let text: String
    let dimOpacity: Double
}

struct TutorialPagesScene: View {
    let cfg: TutorialPagesStepConfig
    let onNext: () -> Void

    @StateObject private var board = BoardViewModel(pages: BoardDefinition.makePages())

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            BoardSpotlightOverlay(
                board: board,
                pageId: cfg.pageId,
                mode: .allTilesAndTab,
                text: cfg.text,
                dimOpacity: cfg.dimOpacity,
                cardMaxWidth: 600,
                cardMinWidth: 320,
                cardHeight: 72,
                cardTopPadding: 0,
                cardY: 120
            )

            Button {
                AudioSystem.shared.playSFX("ApplePCClick")
                onNext()
            } label: {
                Image("NextButton")
            }
           // .buttonStyle(PressableButtonStyle())

                .padding(28)
                .shadow(radius: 2, y: 4)
        }
        .ignoresSafeArea()
    }
}

