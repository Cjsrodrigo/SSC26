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
                let cfg = flow.introCards[min(step, flow.introCards.count - 1)]
                TextCardScene(
                    text: cfg.text,
                    dimOpacity: cfg.dimOpacity,
                    onNext: { flow.nextIntro() }
                )

            case .introImage:
                IntroImageView(onNext: { flow.nextIntro() })

            case .askIntroCard:
                let cfg = flow.askIntroCard
                TextCardScene(
                    text: cfg.text,
                    dimOpacity: cfg.dimOpacity,
                    onNext: { flow.nextAfterAskIntroCard() }
                )

            case .askAutoModeling:
                AskAutoModelingView(onNext: { flow.nextAfterAskAutoModeling() })

            case .askAfterBreadcrumb:
                let cfg = flow.askAfterBreadcrumbCard
                TextCardScene(
                    text: cfg.text,
                    dimOpacity: cfg.dimOpacity,
                    onNext: { flow.nextAfterAskAfterBreadcrumb() }
                )

            // ✅ PDFs do GID (GID1..3)
//            case .generalInteractive(let step):
//                let names = flow.gidPdfNames
//                PDFScene(
//                    pdfNameNoExt: names[min(step, names.count - 1)],
//                    onNext: { flow.nextGeneralInteractive() }
//                )

            case .generalInteractive(let step):
                let steps = flow.generalInteractiveSteps
                GeneralInteractiveScene(
                    cfg: steps[min(step, steps.count - 1)],
                    onNext: { flow.nextGeneralInteractive() }
                )

                
            // ✅ missão: montar "I don't like it"
            case .refuseChallenge:
                PhraseChallengeView(
                    cfg: flow.refuseChallengeCfg,
                    onNext: { flow.nextAfterRefuseChallenge() }
                )

            // ✅ tutorial 1: message box
            case .refuseTutorialMessageBox:
                SpotlightTutorialScene(
                    cfg: flow.refuseTutMsgBoxCfg,
                    onNext: { flow.nextAfterRefuseTutorialMessageBox() }
                )

            // ✅ tutorial 2: top controls
            case .refuseTutorialTopControls:
                SpotlightTutorialScene(
                    cfg: flow.refuseTutTopControlsCfg,
                    onNext: { flow.nextAfterRefuseTutorialTopControls() }
                )

//            // ✅ PDFs TutorialPag1..4
//            case .tutorialPdf(let step):
//                let names = flow.tutorialPdfNames
//                PDFScene(
//                    pdfNameNoExt: names[min(step, names.count - 1)],
//                    onNext: { flow.nextTutorialPdf() }
//                )
            case .tutorialPdf(let step):
                let steps = flow.tutorialPageSteps
                TutorialPagesScene(
                    cfg: steps[min(step, steps.count - 1)],
                    onNext: { flow.nextTutorialPdf() }
                )

            // ✅ último challenge: "I like Apple"
            case .likeAppleChallenge:
                PhraseChallengeView(
                    cfg: flow.likeAppleChallengeCfg,
                    onNext: { flow.nextAfterLikeAppleChallenge() }
                )

            // ✅ 4 telas finais (TextCardScene)
            case .postLikeAppleText(let step):
                let cards = flow.postLikeAppleCards
                let cfg = cards[min(step, cards.count - 1)]
                TextCardScene(
                    text: cfg.text,
                    dimOpacity: cfg.dimOpacity,
                    onNext: { flow.nextPostLikeAppleText() }
                )

            // seus casos que já existiam
            case .refuseChallengeIntro:
                BoardView()

            case .freeBoard:
                BoardView()

            case .autoPhrase:
                BoardView()
            }
        }
    }
}
