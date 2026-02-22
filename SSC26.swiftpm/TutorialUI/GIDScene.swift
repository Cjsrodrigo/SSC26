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
                if #available(iOS 17.0, *) {
                    BoardViewContent(vm: board)
                      .allowsHitTesting(false)
                      .onAppear { board.currentPageId = cfg.pageId }
                      .onChange(of: cfg.pageId) { _, newPage in
                        withAnimation(.easeInOut(duration: 0)) {
                          board.currentPageId = newPage
                        }
                      }
                      .overlayPreferenceValue(GuidedAnchorKey.self) { anchors in
                        GeometryReader { proxy in
                          ZStack {
                              if cfg.highlightGridAndTab {
                                  let pageId = board.currentPageId
                                  let tiles = board.currentPage.tiles

                                  let gridRect: CGRect? = anchors[.grid(pageId: pageId)].map { proxy[$0] }

                                  // mesmos valores do BoardViewContent (igual AutoRun)
                                  let tileSize: CGFloat = 85
                                  let gridSpacing: CGFloat = 22
                                  let rowSpacing: CGFloat = 16
                                  let cols = 6

                                  // ✅ Closure (não "func") pra não quebrar o ViewBuilder
                                  let rectForTile: (String) -> CGRect? = { label in
                                      // 1) tenta pelo anchor do tile (se existir)
                                      if let a = anchors[.tile(pageId: pageId, label: label)] {
                                          return proxy[a]
                                      }

                                      // 2) fallback: calcula pelo grid + índice
                                      guard let gridRect,
                                            let idx = tiles.firstIndex(where: { $0.label == label }) else {
                                          return nil
                                      }

                                      let row = idx / cols
                                      let col = idx % cols

                                      let x = gridRect.minX + CGFloat(col) * (tileSize + gridSpacing)
                                      let y = gridRect.minY + CGFloat(row) * (tileSize + rowSpacing)

                                      return CGRect(x: x, y: y, width: tileSize, height: tileSize)
                                  }

                                  let tileRects: [CGRect] = tiles.compactMap { rectForTile($0.label) }
                                      .map { $0.insetBy(dx: -0, dy: -0) }

                                  let tabRect: CGRect? = anchors[.tab(pageId: pageId)].map { proxy[$0] }
                                  let holes: [CGRect] = tileRects + (tabRect.map { [$0] } ?? [])

                                  SpotlightMask(
                                      holes: tileRects,          // ✅ só tiles aqui
                                      strokeRect: nil,           // ✅ pode deixar nil
                                      dimOpacity: cfg.dimOpacity,
                                      cornerRadius: 8,
                                      holePadding: 0,
                                      strokeWidth: 3,
                                      strokeColor: .white,
                                      customHole: tabRect.map { (rect: $0, tl: 18, tr: 18, bl: 6, br: 6) },
                                      customStroke: tabRect.map { (rect: $0, tl: 18, tr: 18, bl: 6, br: 6) }
                                  )

                                  // ✅ desenhar tiles por cima do dim usando o mesmo rect calculado
                                  ForEach(tiles, id: \.id) { tile in
                                      if let r = rectForTile(tile.label) {
                                          TileView(tile: tile, size: r.width)
                                              .frame(width: r.width, height: r.height)
                                              .position(x: r.midX, y: r.midY)
                                              .allowsHitTesting(false)
                                              .zIndex(50)
                                      }
                                  }
                              } else {
                                  Color.black.opacity(cfg.dimOpacity).ignoresSafeArea()
                              }

                            TutorialCard(
                              text: cfg.text,
                              maxWidth: 600,
                              minWidth: 320,
                              height: 72,
                              topPadding: 0
                            )
                            .position(x: proxy.size.width * 0.50, y: 120 + cfg.cardTopPadding)
                          }
                        }
                      }

                        
                } else {
                    // Fallback on earlier versions
                }

                Button {
                    AudioSystem.shared.playSFX("ApplePCClick")
                    onNext()
                } label: {
                    Image("NextButton")
                }
    //            .buttonStyle(PressableButtonStyle())

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
