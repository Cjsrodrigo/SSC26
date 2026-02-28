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
    let expectedMessageNormalized: String
    let words: [String]
}

struct PhraseChallengeView: View {
    let cfg: PhraseChallengeConfig
    let onNext: () -> Void
    
    @StateObject private var board = BoardViewModel(pages: BoardDefinition.makePages())
    
    @State private var stepIndex: Int = 0
    @State private var flashError: Bool = false
    @State private var didAutoAdvance: Bool = false
    
    var body: some View {
        ZStack {
            if #available(iOS 17.0, *) {
                BoardViewContent(vm: board)
                    .onAppear {
                        board.clearAll()
                        stepIndex = 0
                        flashError = false
                        didAutoAdvance = false
                        
                        withAnimation(.easeInOut(duration: 0.2)) {
                            board.currentPageId = cfg.startPageId
                        }
                        
                        board.sidebarTapGuard = { false }
                        board.onInvalidSidebarTap = { triggerErrorFlash() }
                        board.allowedTileLabels = cfg.allowedTileLabels
                        
                        board.tileTapGuard = { tappedLabel in
                            let synced = computeStepIndex(from: board.tokens)
                            if synced != stepIndex { stepIndex = synced }
                            
                            guard stepIndex < cfg.words.count else { return false }
                            
                            let expected = cfg.words[stepIndex]
                            if normalizeLabel(tappedLabel) == normalizeLabel(expected) {
                                stepIndex += 1
                                return true
                            } else {
                                triggerErrorFlash()
                                return false
                            }
                        }
                        
                        board.onInvalidTileTap = { _ in
                            triggerErrorFlash()
                        }
                    }
                    .onDisappear {
                        board.allowedTileLabels = nil
                        board.onInvalidTileTap = nil
                        board.tileTapGuard = nil
                        board.sidebarTapGuard = nil
                        board.onInvalidSidebarTap = nil
                    }
                    .onChange(of: board.tokens) { _, newTokens in
                        let newStep = computeStepIndex(from: newTokens)
                        if newStep != stepIndex {
                            stepIndex = newStep
                        }
                    }
                    .onChange(of: isCompleted) { _, done in
                        guard done, !didAutoAdvance else { return }
                        didAutoAdvance = true
                        
                        Task { @MainActor in
                            sleep(UInt32(1.7))
                            board.speakMessage()
                            
                            try? await Task.sleep(nanoseconds: 1_600_000_000) // 1.6s
                            
                            onNext()
                        }
                    }
                    .overlayPreferenceValue(GuidedAnchorKey.self) { anchors in
                        GeometryReader { proxy in
                            let msgRect: CGRect? = anchors[GuidedTarget.messageBox].map { proxy[$0] }
                            let hudWidth: CGFloat = msgRect?.width ?? 360
                            let hudX: CGFloat = msgRect?.midX ?? (proxy.size.width * 0.5)
                            
                            ChallengeHUD(
                                title: cfg.title,
                                words: cfg.words,
                                highlightedCount: stepIndex,
                                flashError: flashError,
                                width: hudWidth
                            )
                            .position(x: hudX, y: 175)
                        }
                    }
            }
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
    
    private func normalizeLabel(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    private func computeStepIndex(from tokens: [String]) -> Int {
        let n = min(tokens.count, cfg.words.count)
        var i = 0
        while i < n {
            if normalizeLabel(tokens[i]) == normalizeLabel(cfg.words[i]) {
                i += 1
            } else {
                break
            }
        }
        return i
    }
    
    private func triggerErrorFlash() {
        flashError = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 180_000_000)
            flashError = false
        }
    }
}
