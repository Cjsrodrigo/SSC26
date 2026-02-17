//
//  PhraseChallengeView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 15/02/26.
//

import SwiftUI

struct PhraseChallengeConfig {
    let title: String
    let startPageId: Int
    let allowedTileLabels: Set<String>
    let expectedMessageNormalized: String   // ex: "i don't like it"
    let words: [String]                    // ✅ breadcrumb (ex: ["I","Don't","Like","It"])
}

struct PhraseChallengeView: View {
    let cfg: PhraseChallengeConfig
    let onNext: () -> Void

    @StateObject private var board = BoardViewModel(pages: BoardDefinition.makePages())

    @State private var highlightedCount: Int = 0
    @State private var flashError: Bool = false
    @State private var lastTokenCount: Int = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            if #available(iOS 17.0, *) {
                BoardViewContent(vm: board)
                    .onAppear {
                        board.clearAll()
                        highlightedCount = 0
                        lastTokenCount = 0
                        
                        withAnimation(.easeInOut(duration: 0.2)) {
                            board.currentPageId = cfg.startPageId
                        }
                        
                        // ✅ trava tiles permitidos
                        board.allowedTileLabels = cfg.allowedTileLabels
                        
                        // ✅ quando tocar errado: não adiciona token (gate já bloqueia)
                        // e faz o HUD/breadcrumb piscar vermelho
                        board.onInvalidTileTap = { _ in
                            triggerErrorFlash()
                        }
                    }
                    .onDisappear {
                        board.allowedTileLabels = nil
                        board.onInvalidTileTap = nil
                    }
                // ✅ atualiza breadcrumb quando tokens aumentam (acerto)
                    .onChange(of: board.tokens) { _, newTokens in
                        // somente quando realmente adicionou token
                        if newTokens.count > lastTokenCount {
                            highlightedCount = min(newTokens.count, cfg.words.count)
                            lastTokenCount = newTokens.count
                        } else {
                            // erase/clear
                            highlightedCount = min(newTokens.count, cfg.words.count)
                            lastTokenCount = newTokens.count
                        }
                    }
                // ✅ HUD no mesmo lugar do autorun
                    .overlay {
                        GeometryReader { proxy in
                            ChallengeHUD(
                                title: cfg.title,
                                words: cfg.words,
                                highlightedCount: highlightedCount,
                                flashError: flashError
                            )
                            .position(x: proxy.size.width * 0.388, y: 175)
                        }
                    }
            } else {
                // Fallback on earlier versions
            }

            Button(action: onNext) { Image("NextButton") }
                .padding(28)
                .shadow(radius: 2, y: 4)
                .opacity(isCompleted ? 1.0 : 0.45)
                .disabled(!isCompleted)
        }
        .ignoresSafeArea()
    }

    private var isCompleted: Bool {
        normalize(board.messageText) == cfg.expectedMessageNormalized
    }

    private func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "  ", with: " ")
            .lowercased()
    }

    private func triggerErrorFlash() {
        // evita “travar” se spam clicar
        flashError = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 180_000_000) // 0.18s
            flashError = false
        }
    }
}
