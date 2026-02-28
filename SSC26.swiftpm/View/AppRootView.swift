//
//  AppRouteView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

struct AppRootView: View {
    @StateObject private var flow = AppFlowViewModel()
    
    @AppStorage("expresso.appearance") private var appearanceRaw: String = AppAppearance.light.rawValue
    
    private var appearanceValue: AppAppearance { AppAppearance(rawValue: appearanceRaw) ?? .light }
    
    var body: some View {
        ZStack {
            switch flow.route {
                
            case .mainMenu:
                MainMenuView(flow: flow)
                
            case .aboutMe:
                AboutMeView(onBack: { flow.goMainMenu() })
                
            case .intro(let step):
                let cfg = flow.introCards[min(step, flow.introCards.count - 1)]
                TextCardScene(
                    text: cfg.text,
                    dimOpacity: cfg.dimOpacity,
                    onNext: { flow.nextIntro() },
                    textAlignment: cfg.textAlignment
                    
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
                
                
                
            case .generalInteractive(let step):
                let steps = flow.generalInteractiveSteps
                GeneralInteractiveScene(
                    cfg: steps[min(step, steps.count - 1)],
                    onNext: { flow.nextGeneralInteractive() }
                )
                
                
                
                
            case .refuseTutorialMessageBox:
                SpotlightTutorialScene(
                    cfg: flow.refuseTutMsgBoxCfg,
                    onNext: { flow.nextAfterRefuseTutorialMessageBox() }
                )
                
            case .refuseTutorialTopControls:
                SpotlightTutorialScene(
                    cfg: flow.refuseTutTopControlsCfg,
                    onNext: { flow.nextAfterRefuseTutorialTopControls() }
                )
                
                
            case .tutorialPdf(let step):
                let steps = flow.tutorialPageSteps
                TutorialPagesScene(
                    cfg: steps[min(step, steps.count - 1)],
                    onNext: { flow.nextTutorialPdf() }
                )
                
            case .likeAppleChallenge:
                PhraseChallengeView(
                    cfg: flow.likeAppleChallengeCfg,
                    onNext: { flow.nextAfterLikeAppleChallenge() }
                )
                
            case .postLikeAppleText(let step):
                let cards = flow.postLikeAppleCards
                let cfg = cards[min(step, cards.count - 1)]
                TextCardScene(
                    text: cfg.text,
                    dimOpacity: cfg.dimOpacity,
                    onNext: { flow.nextPostLikeAppleText() },
                    textAlignment: cfg.textAlignment
                    
                )
                
            case .freeBoard:
                BoardView()
                
            case .refuseChallengeIntro:
                BoardView()
                
            case .autoPhrase:
                BoardView()
            }
        } .preferredColorScheme(appearanceValue.colorScheme)
            .environmentObject(flow)
        
    }
}
