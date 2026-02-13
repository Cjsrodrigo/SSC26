//
//  AppRouteView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

struct AppRootView: View {
    @StateObject private var flow = AppFlowViewModel()

    var body: some View {
        ZStack {
            switch flow.route {

            case .intro(let step):
                IntroOverlayView(
                    text: flow.introTexts[step],
                    onNext: { flow.nextIntro() }
                )

            case .introImage:
                IntroImageView(onNext: { flow.nextIntro() })

                case .askIntroCard:
                    InstructionOverlayView(
                        sceneTitle: "Missao Pedir 1",
                        text: "I'll dtesto this one by modelling it, to show you how to build phrases, watch it closely, the next challenge is up to you.",
                        onNext: { flow.nextAfterAskIntroCard() }
                    )

                case .askAutoModeling:
                    AskAutoModelingView(
                        onNext: { flow.goFreeBoard() } // por enquanto vai pro modo livre (depois apontamos pro próximo desafio)
                    )
                


            case .freeBoard:
                BoardView()
                
            case .autoPhrase:
                BoardView()

            }
        }
    }
}
