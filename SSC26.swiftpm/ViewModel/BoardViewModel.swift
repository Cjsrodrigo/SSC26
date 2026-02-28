//
//  BoardViewModel.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

@MainActor
final class BoardViewModel: ObservableObject {
    @Published var currentPageId: Int = 1
    @Published var tokens: [String] = []
    @Published var isYesNoPresented: Bool = false
    @Published var highlightCount: Int = 0
    
    var allowedTileLabels: Set<String>? = nil
    var onInvalidTileTap: ((BookTile) -> Void)? = nil
    
    var sidebarTapGuard: (() -> Bool)? = nil
    var onInvalidSidebarTap: (() -> Void)? = nil
    
    let tts = SpeechService.shared
    let pages: [BookPage]
    
    init(pages: [BookPage]) {
        self.pages = pages
    }
    
    var currentPage: BookPage {
        pages.first(where: { $0.id == currentPageId }) ?? pages[0]
    }
    
    var messageText: String {
        tokens.joined(separator: " ")
    }
    
    var tileTapGuard: ((String) -> Bool)? = nil
    
    
    func tryTapTile(_ tile: BookTile) {
        if let allowed = allowedTileLabels, !allowed.contains(tile.label) {
            onInvalidTileTap?(tile)
            return
        }
        tapTile(tile)
    }
    
    func tryTapSidebarAction(_ action: () -> Void) {
        if let guardFn = sidebarTapGuard, guardFn() == false {
            onInvalidSidebarTap?()
            return
        }
        action()
    }
    
    func tapTile(_ tile: BookTile) {
        tts.speak(tile.speakText)
        
        if let guardFn = tileTapGuard, guardFn(tile.label) == false {
            onInvalidTileTap?(tile)
            return
        }
        
        
        switch tile.kind {
        case .word:
            if let t = tile.appendText, !t.isEmpty {
                tokens.append(t)
            }
            
        case .action(let action):
            switch action {
            case .backToPage1:
                currentPageId = 1
                
            case .openYesNoBoard:
                isYesNoPresented = true
            }
        }
    }
    
    func speakMessage() {
        let text = messageText
        if text.trimmingCharacters(in: .whitespacesAndNewlines).count == 1 {
            tts.speak(text.lowercased())
        } else {
            tts.speak(text)
        }
    }
    
    
    func copyMessage() {
#if canImport(UIKit)
        UIPasteboard.general.string = messageText
#endif
    }
    
    func eraseLast() {
        guard !tokens.isEmpty else { return }
        tokens.removeLast()
    }
    
    func clearAll() {
        tokens.removeAll()
    }
    
    
    
}
