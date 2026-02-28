//
//  AppRoute.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

enum AppRoute: Equatable {
    
    case mainMenu
    case aboutMe
    
    
    case intro(step: Int)
    case introImage
    
    case askIntroCard
    case askAutoModeling
    case askAfterBreadcrumb
    
    case generalInteractive(step: Int)
    
    case refuseChallengeIntro
    case refuseTutorialMessageBox
    case refuseTutorialTopControls
    
    case tutorialPdf(step: Int)
    case likeAppleChallenge
    case postLikeAppleText(step: Int)
    
    case freeBoard
    case autoPhrase
    
    
}
