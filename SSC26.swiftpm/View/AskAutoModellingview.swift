//
//  AskAutoModellingview.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI

@MainActor
final class AskAutoRunner: ObservableObject {
    @Published var activeTarget: GuidedTarget? = nil
    @Published var finished: Bool = false
    @Published var breadcrumbHighlightedCount: Int = 0
    @Published var dimEnabled: Bool = true   // ✅ NOVO

    private var task: Task<Void, Never>?

    
    
    func start(board vm: BoardViewModel) {
        
        
        guard task == nil else { return }

        
        
        task = Task { @MainActor in
            finished = false
            dimEnabled = true
            vm.clearAll()
            breadcrumbHighlightedCount = 0

            let page1 = 1
            let page2 = 2

            let tI    = GuidedTarget.tile(pageId: page1, label: "I")
            let tWant = GuidedTarget.tile(pageId: page1, label: "Want")
            let tab2  = GuidedTarget.tab(pageId: page2)
            let tPlay = GuidedTarget.tile(pageId: page2, label: "Play")
            let tab1  = GuidedTarget.tab(pageId: page1)
            let tMore = GuidedTarget.tile(pageId: page1, label: "More")

            withAnimation(.easeInOut(duration: 0.25)) { vm.currentPageId = page1 }
            await sleep(0.20)

            // I
            await sleep(1.20)
            activeTarget = tI
            await sleep(0.5)
            tapTile(label: "I", vm: vm)
            withAnimation(.easeInOut(duration: 0.15)) { breadcrumbHighlightedCount = 1 }
            await sleep(2.3)

            // Want
            activeTarget = tWant
            await sleep(0.9)
            tapTile(label: "Want", vm: vm)
            await sleep(0.9)

            withAnimation(.easeInOut(duration: 0.20)) { breadcrumbHighlightedCount = 2 }

            // Tab 2
            activeTarget = tab2
            await sleep(1.20)
            withAnimation(.easeInOut(duration: 0.25)) { vm.currentPageId = page2 }
            await sleep(0.30)

            // Play
            activeTarget = tPlay
            await sleep(0.9)
            tapTile(label: "Play", vm: vm)
            await sleep(0.9)
            withAnimation(.easeInOut(duration: 0.20)) { breadcrumbHighlightedCount = 3 }

            // Tab 1
            activeTarget = tab1
            await sleep(1.20)
            withAnimation(.easeInOut(duration: 0.25)) { vm.currentPageId = page1 }
            await sleep(0.30)

            // More
            activeTarget = tMore
            await sleep(0.8)
            tapTile(label: "More", vm: vm)
            await sleep(0.9)

            withAnimation(.easeInOut(duration: 0.20)) { breadcrumbHighlightedCount = 4 }

            // ✅ some o dim e mantém o HUD completo na tela
            dimEnabled = false
            activeTarget = nil

            await sleep(1.20)

            // ✅ fala SEM overlay (sem highlight no speak)
            vm.speakMessage()

            // ✅ mantém o breadcrumb completo mais um pouco
            await sleep(1.20)

            finished = true
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }

    private func tapTile(label: String, vm: BoardViewModel) {
        if let tile = vm.currentPage.tiles.first(where: { $0.label == label }) {
            vm.tapTile(tile)
        }
    }

    private func sleep(_ seconds: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

struct AskAutoModelingView: View {
    let onNext: () -> Void

    @StateObject private var board = BoardViewModel(pages: BoardDefinition.makePages())
    @StateObject private var runner = AskAutoRunner()
    @State private var cachedTargetRect: CGRect? = nil
    @State private var rectCache: [GuidedTarget: CGRect] = [:]
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            if #available(iOS 17.0, *) {
                BoardViewContent(vm: board)
                    .allowsHitTesting(false)
                    .onAppear {
                        
                        // ✅ aquece para essa tela também
                                AudioSystem.shared.warmUp()
                                SpeechService.shared.warmUp()

                                // ✅ opcional: “prime” do TTS (explico abaixo)
                                SpeechService.shared.primeForFirstSpeak()
                        
                        runner.start(board: board)
                    }
                    .onDisappear { runner.cancel() }
                    .onChange(of: runner.finished) { _, done in
                        guard done else { return }
                        // ✅ segura HUD completo e vai automaticamente
                        Task { @MainActor in
                            try? await Task.sleep(nanoseconds: 1_400_000_000)
                            onNext()
                        }
                    }
                    .overlayPreferenceValue(GuidedAnchorKey.self) { anchors in
                        GeometryReader { proxy in
                            let words = ["I", "Want", "Play", "More"]

                            let msgRect: CGRect? = anchors[GuidedTarget.messageBox].map { proxy[$0] }

                            let hudWidth: CGFloat = msgRect?.width ?? 360
                            let hudX: CGFloat = msgRect?.midX ?? (proxy.size.width * 0.5)

                            let hud = ChallengeHUD(
                                title: "Just watch: Ask",
                                words: words,
                                highlightedCount: runner.breadcrumbHighlightedCount
                                // flashError: false (pode omitir)
                                , width: hudWidth
                            )
                            .position(x: hudX, y: 175)


                            // ✅ Calcula o rect do target SEM mutação (ViewBuilder-safe)
                            let targetRect: CGRect? = {
                                // 1) tenta pelo anchor do target (quando existe)
                                if let t = runner.activeTarget,
                                   let a = anchors[t] {
                                    return proxy[a]
                                }

                                // 2) fallback: se for tile e anchor veio nil, calcula pelo grid + índice
                                guard let t = runner.activeTarget,
                                      case let .tile(pageId, label) = t,
                                      pageId == board.currentPageId,
                                      let gridA = anchors[.grid(pageId: board.currentPageId)] else {
                                    return nil
                                }

                                let gridRect = proxy[gridA]

                                // mesmos valores do BoardViewContent
                                let tileSize: CGFloat = 85
                                let gridSpacing: CGFloat = 22
                                let rowSpacing: CGFloat = 16
                                let cols = 6
                                

                                guard let idx = board.currentPage.tiles.firstIndex(where: { $0.label == label }) else {
                                    return nil
                                }

                                let row = idx / cols
                                let col = idx % cols

                                let x = gridRect.minX + CGFloat(col) * (tileSize + gridSpacing)
                                let y = gridRect.minY + CGFloat(row) * (tileSize + rowSpacing)

                                return CGRect(x: x, y: y, width: tileSize, height: tileSize)
                            }()
                            
                            


                            if runner.dimEnabled {
                                let holes = [targetRect, msgRect].compactMap { $0 }
                                
                               

                                ZStack {
                                    let isTabTarget: Bool = {
                                        guard let t = runner.activeTarget else { return false }
                                        if case .tab = t { return true }
                                        return false
                                    }()

                                    let isTileTarget: Bool = {
                                        guard let t = runner.activeTarget else { return false }
                                        if case .tile = t { return true }
                                        return false
                                    }()
                                    
                                    SpotlightMask(
                                        holes: isTabTarget ? ([msgRect].compactMap { $0 }) : holes,
                                        strokeRect: (isTabTarget || isTileTarget) ? nil : targetRect, 
                                        dimOpacity: 0.90,
                                        cornerRadius: 8,
                                        holePadding: 0,
                                        strokeWidth: 3,
                                        strokeColor: .white,
                                        customHole: (isTabTarget && targetRect != nil)
                                            ? (rect: targetRect!,
                                               tl: 18, tr: 18, bl: 6, br: 6)
                                            : nil,
                                        customStroke: (isTabTarget && targetRect != nil)
                                            ? (rect: targetRect!,
                                               tl: 18, tr: 18, bl: 6, br: 6)
                                            : nil
                                    )

                                    

                                    // ✅ desenha o tile por cima do dim (agora targetRect existe via fallback)
                                    if let r = targetRect,
                                       let target = runner.activeTarget,
                                       case let .tile(pageId, label) = target,
                                       let page = board.pages.first(where: { $0.id == pageId }),
                                       let tile = page.tiles.first(where: { $0.label == label }) {

                                        TileView(tile: tile, size: r.width)
                                            .frame(width: r.width, height: r.height)
                                            .position(x: r.midX, y: r.midY)
                                            .allowsHitTesting(false)
                                            .zIndex(50)
                                    }

                                    hud
                                        .zIndex(100)
                                }
                            } else {
                                hud
                            }
                        }
                    }
            }
        }
        .ignoresSafeArea()
    }
}


#if swift(>=5.9)
@available(iOS 17.0, *)
#Preview(traits: .landscapeRight) {
    AskAutoModelingView(onNext: {})
}
#endif

