//
//  AppRoute.swift
//  SSC26
//
//  Created by Rodrigo Cont on 12/02/26.
//

import SwiftUI

enum AppRoute: Equatable {
    case mainMenu                      // ✅ NOVO
     case aboutMe  
    
    
    case intro(step: Int)     // 0...N-1
    case introImage           // a tela que você disse que é “uma imagem feita por mim”
    
    case askIntroCard          // ✅ tela do balão (Missão Pedir 1)
    case askAutoModeling       // ✅ tutorial automático (Missão Pedir 2)
    case askAfterBreadcrumb
    case generalInteractive(step: Int)
  //  case refuseChallenge
    case refuseChallengeIntro

    case refuseTutorialMessageBox
    case refuseTutorialTopControls
    case tutorialPdf(step: Int)   // TutorialPag1..4
    case likeAppleChallenge
    case postLikeAppleText(step: Int)
    
      case freeBoard
      case autoPhrase       // modo livre (final)
    
    
}
