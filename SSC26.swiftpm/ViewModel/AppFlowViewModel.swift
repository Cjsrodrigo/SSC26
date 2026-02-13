//
//  AppFlowViewModel.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

@MainActor
final class AppFlowViewModel: ObservableObject {
    @Published var route: AppRoute = .intro(step: 0)

    // 4 telas de texto (edite depois com seus textos finais)
    let introTexts: [String] = [
        "PODD is a type of augmentative and alternative communication that helps people communicate using organized vocabulary, promoting autonomy through functional and broad language to everyone who needs support to express themselves.",
        "The Programmatic Organization Dynamic Display is regognized as one of the most important and emerging methodologies of AAC.",
        "Nearly 100 million people around the globe have the need to use AAC.    \n                 Beukelman & Light, 2020.",
        "You’ll learn the basics of Programmatic Organization Dynamic Display (PODD) by watching modeling and completing 2 quick missions."
    ]

    func nextIntro() {
        switch route {
        case .intro(let step):
            if step < introTexts.count - 1 {
                route = .intro(step: step + 1)
            } else {
                route = .introImage
            }

        case .introImage:
            route = .askIntroCard   // próximo bloco do seu roteiro

        default:
            break
        }
    }

    func nextAfterAskIntroCard() {
        route = .askAutoModeling
    }
    
    func goFreeBoard() {
        route = .freeBoard
    }
}
