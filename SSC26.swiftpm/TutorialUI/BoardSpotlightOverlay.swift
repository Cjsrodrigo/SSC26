//
//  BoardSpotlightOverlay.swift
//  SSC26
//
//  Created by Rodrigo Cont on 18/02/26.
//

//
//  BoardSpotlightOverlay.swift
//  SSC26
//
//  Shared overlay for Board + SpotlightMask + TutorialCard
//

import SwiftUI

/// Overlay reutilizável: Board + dim + holes + stroke + TutorialCard.
/// Evita repetir overlayPreferenceValue/GeometryReader/rectForTile em todas as scenes.
struct BoardSpotlightOverlay: View {

    enum HoleMode {
        /// Evidencia todos os tiles da página atual + a tab da página.
        /// Usa fallback por grid caso anchors de tiles não existam.
        case allTilesAndTab

        /// Evidencia targets específicos (ex.: messageBox/speak/copy/erase).
        /// Nesse modo NÃO usa fallback de tile (porque não é necessário).
        case targets(holes: [GuidedTarget], stroke: GuidedTarget?)
    }

    @ObservedObject var board: BoardViewModel
    let pageId: Int

    let mode: HoleMode
    
    var text: String
    var dimOpacity: Double = 0.90

    // Card
    var cardMaxWidth: CGFloat = 600
    var cardMinWidth: CGFloat = 320

    var cardHeight: CGFloat = 72
    var cardTopPadding: CGFloat = 0
    var cardY: CGFloat? = 120

    // Hole styling
    var cornerRadius: CGFloat = 8
    var holePadding: CGFloat = 0
    var strokeWidth: CGFloat = 3
    var strokeColor: Color = .white

    // Tab custom (Uneven)
    var useUnevenTab: Bool = true
    var tabTL: CGFloat = 18
    var tabTR: CGFloat = 18
    var tabBL: CGFloat = 6
    var tabBR: CGFloat = 6

    // Grid fallback metrics (devem bater com BoardViewContent)
    var tileSize: CGFloat = 85
    var gridSpacing: CGFloat = 22
    var rowSpacing: CGFloat = 16
    var cols: Int = 6

    var body: some View {
        // ✅ garantir que ocupa tela toda (senão SpotlightMask “some”)
        if #available(iOS 17.0, *) {
            ZStack {
                BoardViewContent( vm: board)
                    .allowsHitTesting(false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear {
                board.currentPageId = pageId
            }
            .onChange(of: pageId) { _, newPage in
                withAnimation(.easeInOut(duration: 0)) {
                    board.currentPageId = newPage
                }
            }
            .overlayPreferenceValue(GuidedAnchorKey.self) { anchors in
                GeometryReader { proxy in
                    ZStack {
                        switch mode {
                        case .allTilesAndTab:
                            overlayAllTilesAndTab(anchors: anchors, proxy: proxy)
                            
                        case .targets(let holes, let stroke):
                            overlayTargets(anchors: anchors, proxy: proxy, holes: holes, stroke: stroke)
                        }
                        let y = (cardY ?? (proxy.size.height * 0.50)) + cardTopPadding

                        TutorialCard(
                            text: text,
                            maxWidth: cardMaxWidth,
                            minWidth: cardMinWidth,
                            height: cardHeight,
                            topPadding: 0
                        )

                        .position(x: proxy.size.width * 0.50, y: y)


                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Modes

    @ViewBuilder
    private func overlayTargets(
        anchors: [GuidedTarget: Anchor<CGRect>],
        proxy: GeometryProxy,
        holes: [GuidedTarget],
        stroke: GuidedTarget?
    ) -> some View {

        let rects: [CGRect] = holes.compactMap { t in
            anchors[t].map { proxy[$0] }
        }

        let strokeRect: CGRect? = stroke.flatMap { t in
            anchors[t].map { proxy[$0] }
        }

        SpotlightMask(
            holes: rects,
            strokeRect: strokeRect,
            dimOpacity: dimOpacity,
            cornerRadius: cornerRadius,
            holePadding: holePadding,
            strokeWidth: strokeWidth,
            strokeColor: strokeColor
        )
    }

    @ViewBuilder
    private func overlayAllTilesAndTab(
        anchors: [GuidedTarget: Anchor<CGRect>],
        proxy: GeometryProxy
    ) -> some View {

        let pid = board.currentPageId
        let tiles = board.currentPage.tiles

        let gridRect: CGRect? = anchors[.grid(pageId: pid)].map { proxy[$0] }

        let safeCols = max(cols, 1)

        let rectForTile: (String) -> CGRect? = { label in
            // 1) tenta anchor do tile
            if let a = anchors[.tile(pageId: pid, label: label)] {
                return proxy[a]
            }
            // 2) fallback grid + índice
            guard let gridRect,
                  let idx = tiles.firstIndex(where: { $0.label == label }) else { return nil }

            let row = idx / safeCols
            let col = idx % safeCols

            let x = gridRect.minX + CGFloat(col) * (tileSize + gridSpacing)
            let y = gridRect.minY + CGFloat(row) * (tileSize + rowSpacing)

            return CGRect(x: x, y: y, width: tileSize, height: tileSize)
        }

        let tileRects: [CGRect] = tiles.compactMap { rectForTile($0.label) }
            .map { $0.insetBy(dx: -0, dy: -0) } // fecha “frestas”
        
        let tabRect: CGRect? = anchors[.tab(pageId: pid)].map { proxy[$0] }

        // ✅ holes: tiles sempre.
        // ✅ tab: pode ser normal (strokeRect) ou customHole/customStroke (uneven).
        if useUnevenTab, let tabRect {
            SpotlightMask(
                holes: tileRects,
                strokeRect: nil,
                dimOpacity: dimOpacity,
                cornerRadius: cornerRadius,
                holePadding: holePadding,
                strokeWidth: strokeWidth,
                strokeColor: strokeColor,
                customHole: (rect: tabRect, tl: tabTL, tr: tabTR, bl: tabBL, br: tabBR),
                customStroke: (rect: tabRect, tl: tabTL, tr: tabTR, bl: tabBL, br: tabBR)
            )
        } else {
            let holes = tileRects + (tabRect.map { [$0] } ?? [])
            SpotlightMask(
                holes: holes,
                strokeRect: tabRect,
                dimOpacity: dimOpacity,
                cornerRadius: cornerRadius,
                holePadding: holePadding,
                strokeWidth: strokeWidth,
                strokeColor: strokeColor
            )
        }

        // (Opcional, mas fica igual AutoRun) desenha tiles por cima do dim
        ForEach(tiles, id: \.id) { tile in
            if let r = rectForTile(tile.label) {
                TileView(tile: tile, size: r.width)
                    .frame(width: r.width, height: r.height)
                    .position(x: r.midX, y: r.midY)
                    .allowsHitTesting(false)
                    .zIndex(50)
            }
        }
    }
}
