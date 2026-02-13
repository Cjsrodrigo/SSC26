//
//  AskAutoModellingview.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI

// MARK: - Runner (executa a modelagem automaticamente)

@MainActor
final class AskAutoRunner: ObservableObject {
    @Published var activeTarget: GuidedTarget? = nil
    @Published var finished: Bool = false
    @Published var breadcrumbHighlightedCount: Int = 0

    private var task: Task<Void, Never>?

    func start(board vm: BoardViewModel) {
        guard task == nil else { return }

        task = Task { @MainActor in
            finished = false
            vm.clearAll()
            breadcrumbHighlightedCount = 0

            // Ajuste aqui se suas pages/labels mudarem
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
            activeTarget = tI
            await sleep(1.65)
            tapTile(label: "I", vm: vm)
            withAnimation(.easeInOut(duration: 0.20)) {
                breadcrumbHighlightedCount = 1
            }

            // want
            activeTarget = tWant
            await sleep(1.55)
            tapTile(label: "Want", vm: vm)
            withAnimation(.easeInOut(duration: 0.20)) { breadcrumbHighlightedCount = 2 }


            activeTarget = tab2
             await sleep(0.90)
            
            withAnimation(.easeInOut(duration: 0.25)) { vm.currentPageId = page2 }
                   await sleep(0.20)
            
            // play (troca aba)
            vm.currentPageId = page2
            await sleep(1.25) // dá tempo do layout atualizar a âncora
            activeTarget = tPlay
            await sleep(1.55)
            tapTile(label: "Play", vm: vm)
            withAnimation(.easeInOut(duration: 0.20)) { breadcrumbHighlightedCount = 3 }
            
            activeTarget = tab1
                   await sleep(0.90)

                   // troca para page 1
                   withAnimation(.easeInOut(duration: 0.25)) { vm.currentPageId = page1 }
                   await sleep(0.20)
            
            // more (volta aba)
            vm.currentPageId = page1
            await sleep(1.25)
            activeTarget = tMore
            await sleep(1.55)
            tapTile(label: "More", vm: vm)
            withAnimation(.easeInOut(duration: 0.20)) {
                breadcrumbHighlightedCount = 4
            }

            // speak (fala a frase inteira)
            activeTarget = .speakButton
            await sleep(0.55)
            vm.speakMessage()

            await sleep(0.25)
            activeTarget = nil
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
        let ns = UInt64(seconds * 1_000_000_000)
        try? await Task.sleep(nanoseconds: ns)
    }
}

// MARK: - Spotlight overlay (fundo escuro com “furo” + barra de challenge)

struct SpotlightOverlay: View {
    let holeRect: CGRect
    let title: String
    let highlightedCount: Int
    
    var body: some View {
        GeometryReader { proxy in
            let hole = holeRect.insetBy(dx: 0, dy: 0)

            ZStack(alignment: .topLeading) {

                // Fundo escuro com furo (even-odd)
                Path { p in
                    p.addRect(CGRect(origin: .zero, size: proxy.size))
                    p.addRoundedRect(in: hole, cornerSize: CGSize(width: 8, height: 8))
                }
                .fill(Color.black.opacity(0.90), style: FillStyle(eoFill: true))

                // Borda do highlight
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 3)
                    .frame(width: hole.width, height: hole.height)
                    .position(x: hole.midX, y: hole.midY)

                // Barra “Challenge”
                HStack(spacing: 60) {
                    Text("Challenge")
                        .font(.system(size: 12, weight: .semibold))
                       // .padding(.horizontal, 10)
                      //  .padding(.vertical, 6)
                    //    .background(Color.white.opacity(0.92))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .center, spacing: 3) {
                        Text(title)
                            .font(.system(size: 12, weight: .semibold))
                       
                        BreadcrumbText(
                                                 words: ["I", "Want", "Play", "More"],
                                                 highlightedCount: highlightedCount
                                             )
                           
                    }
                }
                .frame(width: 299)
                .padding(4)
                .background(Color.white.opacity(0.90))
                .clipShape(RoundedRectangle(cornerRadius: 8))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.black.opacity(1), lineWidth: 1)
//                )
                
                // posição semelhante ao seu print (ajuste se quiser)
                .position(x: proxy.size.width * 0.355, y: 175)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - View final

struct AskAutoModelingView: View {
    let onNext: () -> Void

    @StateObject private var board = BoardViewModel(pages: BoardDefinition.makePages())
    @StateObject private var runner = AskAutoRunner()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // Board por trás (sem interação — “just watch”)
            BoardViewContent(vm: board)
                .allowsHitTesting(false)
                .onAppear { runner.start(board: board) }
                .onDisappear { runner.cancel() }

                // Lê as âncoras marcadas no BoardViewContent e desenha o spotlight
                .overlayPreferenceValue(GuidedAnchorKey.self) { anchors in
                    GeometryReader { proxy in
                        if let target = runner.activeTarget,
                           let anchor = anchors[target] {
                            SpotlightOverlay(
                                holeRect: proxy[anchor],
                                title: "Just watch: Ask",
                                highlightedCount: runner.breadcrumbHighlightedCount
                            )

                        }
                    }
                }

            // Botão Next só quando terminar
            if runner.finished {
                Button(action: onNext) {
                    Image("NextButton")
                   
                }
                .padding(28)
                .shadow(radius: 2, y: 4)
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

