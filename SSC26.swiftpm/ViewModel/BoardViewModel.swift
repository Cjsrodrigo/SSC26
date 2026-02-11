//
//  BoardViewModel.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//

import  SwiftUI

#if canImport(UIKit)
import UIKit
#endif

@MainActor

final class BoardViewModel: ObservableObject {
    @Published var currentPageId: Int = 1
    @Published var tokens: [String] = []
    @Published var isYesNoPresented: Bool = false
    
    
    let speech = SpeechService()
    let pages: [PoddPage]
    
    init(pages: [PoddPage]) {
        self.pages = pages
    }
    
    var currentPage: PoddPage {
        
        pages.first(where: { $0.id == currentPageId }) ?? pages[0]
        
    }
    
    var messageText: String {
        tokens.joined(separator: " ")
    }
    
    func tapTile(_ tile: PoddTile) {
        
       speech.speak(tile.speakText)
        
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
        speech.speak(messageText)
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
