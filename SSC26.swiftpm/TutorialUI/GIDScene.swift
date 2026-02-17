//
//  GIDScene.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI

struct GeneralInteractiveStepConfig {
    let sceneTitle: String
    let pageId: Int
    let text: String
    let dimOpacity: Double
    let highlightGridAndTab: Bool
    let cardTopPadding: CGFloat
}
struct GeneralInteractiveScene: View {
    let cfg: GeneralInteractiveStepConfig
    let onNext: () -> Void

    @StateObject private var board = BoardViewModel(pages: BoardDefinition.makePages())

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BoardViewContent(vm: board)
                .allowsHitTesting(false)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        board.currentPageId = cfg.pageId
                    }
                }
                .overlayPreferenceValue(GuidedAnchorKey.self) { anchors in
                    GeometryReader { proxy in
                        ZStack {
                            if cfg.highlightGridAndTab,
                               let gridA = anchors[.grid(pageId: cfg.pageId)],
                               let tabA  = anchors[.tab(pageId: cfg.pageId)] {

                                let gridRect = proxy[gridA].insetBy(dx: -1, dy: -1)
                                let tabRect  = proxy[tabA].insetBy(dx: 0, dy: 0)

                                SpotlightMask(
                                    holes: [gridRect, tabRect],
                                    strokeRect: gridRect,
                                    dimOpacity: cfg.dimOpacity,
                                    strokeWidth: 1, strokeColor: .black
                                )
                            } else {
                                Color.black.opacity(cfg.dimOpacity).ignoresSafeArea()
                            }

                            VStack {
                                TutorialCard(text: cfg.text)
                                
                                    .position(x: proxy.size.width * 0.50, y: 120)
                                  
                            }
                        }
                    }
                }

            Button(action: onNext) { Image("NextButton") }
                .padding(28)
                .shadow(radius: 2, y: 4)
        }
        .ignoresSafeArea()
    }
}
#if swift(>=5.9)
  @available(iOS 17.0, *)
  #Preview("GeneralInteractiveScene", traits: .landscapeRight) {
      let cfg = GeneralInteractiveStepConfig(
          sceneTitle: "Sample",
          pageId: 1,
          text: "Sample instructional text.",
          dimOpacity: 0.6,
          highlightGridAndTab: true,
          cardTopPadding: 0
      )
      GeneralInteractiveScene(cfg: cfg, onNext: {})
  }
  #endif
