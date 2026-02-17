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
    
    
    let tutMsgBox = SpotlightTutorialConfig(
        pageId: 1,
        text: "Awesome, that's it! This is where your speech will be shown",
        dimOpacity: 0.90,
        holes: [.messageBox],
        stroke: .messageBox
    )
    
    let tutTopControls = SpotlightTutorialConfig(
        pageId: 1,
        text: "You can also repeat it out loud, copy it to wherever you want, or erase it",
        dimOpacity: 0.90,
        holes: [.speakButton, .messageBox, .copyButton, .eraseButton],
        stroke: nil
    )
    
    
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
                        let rects: [CGRect] = cfg.holes.compactMap { t in
                            anchors[t].map { proxy[$0] }
                        }
                        
                        let strokeRect: CGRect? = cfg.stroke.flatMap { t in
                            anchors[t].map { proxy[$0] }
                        }
                        
                        ZStack {
                            SpotlightMask(
                                holes: rects,
                                strokeRect: strokeRect,
                                dimOpacity: cfg.dimOpacity,
                                cornerRadius: 8, holePadding: 0,
                                strokeWidth: 3,
                                strokeColor: .white
                            )
                            
                            TutorialCard(text: cfg.text)
                            //  .frame(width: 640, height: 90)
               //                 .position(x: proxy.size.width * 0.50, y: 170)
                            
                        }
                    }
                    
                    Button(action: onNext) { Image("NextButton") }
                        .padding(28)
                        .shadow(radius: 2, y: 4)
                }
                .ignoresSafeArea()
        }
    }
}
