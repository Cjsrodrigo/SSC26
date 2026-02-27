//
//  AppFlowViewModel.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

@MainActor
final class AppFlowViewModel: ObservableObject {

    // MARK: - Current route
    @Published var route: AppRoute = .mainMenu/*.intro(step: 0)*/

    @AppStorage("expresso.finishedOnce") private var finishedOnce: Bool = false
    
    
    // MARK: - (1) Intro (Text cards)
    let introCards: [TextCardConfig] = [
        .init(
            text: "Communication is part of human essence, we continuously find different ways to express ourselves. Augmentative and alternative communication(AAC) is a range of tools and techniques that support or replace spoken communication,",
            dimOpacity: 0.90
        ),
        .init(
            text: "Using symbols to aid communication is one of the most used forms of AAC.",
            dimOpacity: 0.90
        ),
        .init(
            text: "Nearly 100 million people around the globe have the need to use AAC.\n\n(Beukelman & Light,2020)",
            dimOpacity: 0.90,
            textAlignment: .center

        ),
        .init(
            text: "You’ll learn the basics of AAC usage by watching language modeling and completing 2 quick missions.",
            dimOpacity: 0.90
        )
    ]

    // MARK: - (2) Ask flow
    let askIntroCard: TextCardConfig = .init(
        text: "I'll do this one by modelling it, to show you how to build phrases, watch it closely, the next challenge is up to you.",
        dimOpacity: 0.90
    )

    let askAfterBreadcrumbCard: TextCardConfig = .init(
        text: "Playing is so fun, but it's time to go back to class, how about learning more about this method?",
        dimOpacity: 0.90
    )

    // MARK: - (3) GID (General Interactive Display) screens (3)
    let generalInteractiveSteps: [GeneralInteractiveStepConfig] = [
        .init(
            sceneTitle: "GID1",
            pageId: 1,
            text: "In the first two pages you will find a general interaction display, with core words.",
            dimOpacity: 0.90,
            highlightGridAndTab: true,
            cardTopPadding: 0
        ),
        .init(
            sceneTitle: "GID2",
            pageId: 2,
            text: "These core words are used to enable communication across a range of activities and habit aided language.",
            dimOpacity: 0.90,
            highlightGridAndTab: true,
            cardTopPadding: 0
        ),
//        .init(
//            sceneTitle: "GID3",
//            pageId: 1,
//            text: "Great! let's try to communicate that you don't like something using only the general interaction display!",
//            dimOpacity: 0.90,
//            highlightGridAndTab: false,
//            cardTopPadding: 0
//        )
    ]

    var generalInteractiveCount: Int { generalInteractiveSteps.count }

//    // MARK: - (4) Challenge 1: "I don't like it"
//    let refuseChallengeCfg = PhraseChallengeConfig(
//        title: "Tap to say it",
//        startPageId: 1,
//        allowedTileLabels: ["I", "Don't", "Like", "It"],
//        expectedMessageNormalized: "i don't like it",
//        words: ["I", "Don't", "Like", "It"]
//    )

    // MARK: - (5) Tutorials after Challenge 1
    let refuseTutMsgBoxCfg = SpotlightTutorialConfig(
        pageId: 1,
        text: "This is where your speech will be shown",
        dimOpacity: 0.90,
        holes: [.messageBox],
        stroke: .messageBox
    )

    let refuseTutTopControlsCfg = SpotlightTutorialConfig(
        pageId: 1,
        text: "You can also repeat it out loud, copy to wherever you want, or erase it",
        dimOpacity: 0.90,
        holes: [.speakButton, .messageBox, .copyButton, .eraseButton],
        stroke: nil
    )

    // MARK: - (6) Tutorial pages (4) — Play 3 -> Food 4 -> Feelings 5 -> Body 6
    let tutorialPageSteps: [TutorialPagesStepConfig] = [
        .init(
            sceneTitle: "TutorialPag1",
            pageId: 3, // Play 3
            text: "You will have pages representing different aspects of your daily life",
            dimOpacity: 0.90
        ),
        .init(
            sceneTitle: "TutorialPag2",
            pageId: 4, // Food & Drink 4
            text: "These are often customizable to attend the user's personal life",
            dimOpacity: 0.90
        ),
        .init(
            sceneTitle: "TutorialPag3",
            pageId: 5, // Feelings 5
            text: "In this one for example, you can express your feelings a little better",
            dimOpacity: 0.90
        ),
        .init(
            sceneTitle: "TutorialPag4",
            pageId: 6, // Body 6
            text: "You're doing great, now let's try to speak all by yourself",
            dimOpacity: 0.90
        )
    ]

    // MARK: - (7) Challenge 2: "I like Apple"
    let likeAppleChallengeCfg = PhraseChallengeConfig(
        title: "Tap to say it",
        startPageId: 1,
        allowedTileLabels: ["I", "Like", "Apple"],
        expectedMessageNormalized: "i like apple",
        words: ["I", "Like", "Apple"]
    )

    // MARK: - (8) Final text cards (4)
    let postLikeAppleCards: [TextCardConfig] = [
        .init(
            text: "**You did it!**\n\nYou were able to communicate using two communicative functions.\nAsked and commented on something and learn AAC logic.",
            dimOpacity: 0.90,
            textAlignment: .center
        ),
        .init(
            text: "Communication is more than words, it’s choice and independence. AAC helps people express needs, feelings and ideas when speech is hard.\nModeling builds connection, when learning it inclusion becomes real at school, at home, and everywhere.",
            dimOpacity: 0.90
        ),
        .init(
            text: "This is more just an experience, it's a bridge to conection.",
            dimOpacity: 0.90,
            //textAlignment: .center
 
        ),
        
        .init(
            text: "Everyone should have the right to be heard \n\nThis is just the beginning. Now you’re free to explore and express anything.",
            dimOpacity: 0.90,
            textAlignment: .center

        )
    ]

    // -------------------------
    // MARK: - Flow actions (in order)
    // -------------------------

    // (1) Intro -> IntroImage -> AskIntroCard
    func nextIntro() {
        switch route {
        case .intro(let step):
            if step < introCards.count - 1 {
                route = .intro(step: step + 1)
            } else {
                route = .introImage
            }

        case .introImage:
            route = .askIntroCard

        default:
            break
        }
    }

    // (2) Ask flow
    func nextAfterAskIntroCard() { route = .askAutoModeling }
    func nextAfterAskAutoModeling() { route = .askAfterBreadcrumb }
    func nextAfterAskAfterBreadcrumb() { route = .generalInteractive(step: 0) }

    // (3) GID
    func nextGeneralInteractive() {
        guard case .generalInteractive(let step) = route else { return }
        if step < generalInteractiveCount - 1 {
            route = .generalInteractive(step: step + 1)
        } else {
            route = .refuseTutorialMessageBox
        }
    }

    // (4) Challenge 1 -> Tutorials
    func nextAfterRefuseChallenge() { route = .refuseTutorialMessageBox }
    func nextAfterRefuseTutorialMessageBox() { route = .refuseTutorialTopControls }
    func nextAfterRefuseTutorialTopControls() { route = .tutorialPdf(step: 0) }

    // (5) Tutorial pages -> Challenge 2
    func nextTutorialPdf() {
        guard case .tutorialPdf(let step) = route else { return }
        if step < tutorialPageSteps.count - 1 {
            route = .tutorialPdf(step: step + 1)
        } else {
            route = .likeAppleChallenge
        }
    }

    // (6) Challenge 2 -> Final text
    func nextAfterLikeAppleChallenge() { route = .postLikeAppleText(step: 0) }

    // (7) Final text -> Free board
    func nextPostLikeAppleText() {
        guard case .postLikeAppleText(let step) = route else { return }
        if step < postLikeAppleCards.count - 1 {
            route = .postLikeAppleText(step: step + 1)
        } else {
            
            finishedOnce = true
            route = .mainMenu

        }
    }

    func goFreeBoard() { route = .freeBoard }
    
    func goMainMenu() {
           route = .mainMenu
       }

       func startExperience() {
           route = .intro(step: 0)
       }

       func goFreeMode() {
           route = .freeBoard
       }

       func goAboutMe() {
           route = .aboutMe
       }

       var canShowUnlockedButtons: Bool { finishedOnce }
    
    
}
