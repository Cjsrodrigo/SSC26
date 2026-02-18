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

//    // ---- GID PDFs ----
//    let generalInteractiveCount = 3
//    let gidPdfNames = ["GID1", "GID2", "GID3"]
    // ---- GID (telas reais) ----
    let generalInteractiveSteps: [GeneralInteractiveStepConfig] = [
        .init(
            sceneTitle: "GID1",
            pageId: 1,
            text: "In the first two pages you will find a general interaction display, with core words.",
            dimOpacity: 0.80,
            highlightGridAndTab: true,
            cardTopPadding: 0
        ),
        .init(
            sceneTitle: "GID2",
            pageId: 2,
            text: "These core words are used to enable communication across a range of activities, developing the concept of PODD and habit aided language.",
            dimOpacity: 0.80,
            highlightGridAndTab: true,
            cardTopPadding: 0
        ),
        .init(
            sceneTitle: "GID3",
            pageId: 1,
            text: "Great! let's try to communicate that you don't like something using only the general interaction display!",
            dimOpacity: 0.80,
            highlightGridAndTab: false,
            cardTopPadding: 0
        )
    ]

    var generalInteractiveCount: Int { generalInteractiveSteps.count }

    // ---- Tutorial PDFs (4) ----
    let tutorialPdfNames = ["TutorialPag1", "TutorialPag2", "TutorialPag3", "TutorialPag4"]

    // ---- Final text cards (4) ----
    // ✅ você edita os textos aqui
    let postLikeAppleCards: [TextCardConfig] = [
        .init(text: "You did it! \n 🌟🌟🌟 \n You were able to communicate using three communicative functions. Requested, refused and commented on something and learn PODD logic.", dimOpacity: 0.90),
        .init(text: "Communication is more than words, it’s choice and independence. AAC and PODD help people express needs, feelings and ideas when speech is hard. \n Modeling builds connection, when learning it inclusion becomes real at school, at home, and everywhere.", dimOpacity: 0.90),
        .init(text: "We can never really know what a person is capable of until we provide them the opportunity to learn and show us. \n (Gayle Porter, 2009). ", dimOpacity: 0.90),
        .init(text: "Everyone should have the right to be heard \n This is just the beginning. Now you’re free to explore and express anything.", dimOpacity: 0.90)
    ]

    // ---- Intro cards ----
    let introCards: [TextCardConfig] = [
        .init(
            text: "PODD is a type of augmentative and alternative communication that helps people communicate using organized vocabulary, promoting autonomy through functional and broad language to everyone who needs support to express themselves.",
            dimOpacity: 0.90
        ),
        .init(
            text: "The Programmatic Organization Dynamic Display is regognized as one of the most important and emerging methodologies of AAC.",
            dimOpacity: 0.90
        ),
        .init(
            text: "Nearly 100 million people around the globe have the need to use AAC.\nBeukelman & Light, 2020.",
            dimOpacity: 0.90
        ),
        .init(
            text: "You’ll learn the basics of Programmatic Organization Dynamic Display (PODD) by watching modeling and completing 2 quick missions.",
            dimOpacity: 0.90
        )
    ]

    // ---- Ask flow ----
    let askIntroCard: TextCardConfig = .init(
        text: "I'll do this one by modelling it, to show you how to build phrases, watch it closely, the next challenge is up to you.",
        dimOpacity: 0.90
    )

    let askAfterBreadcrumbCard: TextCardConfig = .init(
        text: "Playing is so fun, but it's time to go back to class, how about learning more about this PODD?\n🌟",
        dimOpacity: 0.90
    )

    // ---- Challenges ----
    let refuseChallengeCfg = PhraseChallengeConfig(
        title: "Tap to say it",
        startPageId: 1,
        allowedTileLabels: ["I", "Don't", "Like", "It"],
        expectedMessageNormalized: "i don't like it",
        words: ["I", "Don't", "Like", "It"]
    )

    let likeAppleChallengeCfg = PhraseChallengeConfig(
        title: "Tap to say it",
        startPageId: 1,
        allowedTileLabels: ["I", "Like", "Apple"],
        expectedMessageNormalized: "i like apple",
        words: ["I", "Like", "Apple"]
    )

    // ---- Tutorials pós-refuse ----
    let refuseTutMsgBoxCfg = SpotlightTutorialConfig(
        pageId: 1,
        text: "Awesome, that's it! This is where your speech will be shown",
        dimOpacity: 0.90,
        holes: [.messageBox],
        stroke: .messageBox
    )

    let refuseTutTopControlsCfg = SpotlightTutorialConfig(
        pageId: 1,
        text: "You can also repeat it out loud, copy it to wherever you want, or erase it",
        dimOpacity: 0.90,
        holes: [.speakButton, .messageBox, .copyButton, .eraseButton],
        stroke: nil
    )

    // -------------------------
    // MARK: - Flow actions
    // -------------------------
    func nextIntro() {
        switch route {
        case .intro(let step):
            if step < introCards.count - 1 { route = .intro(step: step + 1) }
            else { route = .introImage }
        case .introImage:
            route = .askIntroCard
        default:
            break
        }
    }

    func nextAfterAskIntroCard() { route = .askAutoModeling }
    func nextAfterAskAutoModeling() { route = .askAfterBreadcrumb }
    func nextAfterAskAfterBreadcrumb() { startGeneralInteractive() }

    func startGeneralInteractive() { route = .generalInteractive(step: 0) }

    func nextGeneralInteractive() {
        guard case .generalInteractive(let step) = route else { return }
        if step < generalInteractiveCount - 1 {
            route = .generalInteractive(step: step + 1)
        } else {
            route = .refuseChallenge
        }
    }

    func nextAfterRefuseChallenge() { route = .refuseTutorialMessageBox }
    func nextAfterRefuseTutorialMessageBox() { route = .refuseTutorialTopControls }

    // ✅ depois do Top Controls, começam os 4 PDFs TutorialPag1..4
    func nextAfterRefuseTutorialTopControls() { route = .tutorialPdf(step: 0) }

    // ✅ avança TutorialPag1..4, depois vai pro último challenge (I like Apple)
    func nextTutorialPdf() {
        guard case .tutorialPdf(let step) = route else { return }
        if step < tutorialPdfNames.count - 1 {
            route = .tutorialPdf(step: step + 1)
        } else {
            route = .likeAppleChallenge
        }
    }

    // ✅ depois do Like Apple, inicia as 4 telas de texto (TextCardScene)
    func nextAfterLikeAppleChallenge() { route = .postLikeAppleText(step: 0) }

    // ✅ avança as 4 telas de texto, depois libera modo livre
    func nextPostLikeAppleText() {
        guard case .postLikeAppleText(let step) = route else { return }
        if step < postLikeAppleCards.count - 1 {
            route = .postLikeAppleText(step: step + 1)
        } else {
            route = .freeBoard
        }
    }

    func goFreeBoard() { route = .freeBoard }
}
