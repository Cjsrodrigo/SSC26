////
////  TutorialCardScene.swift
////  SSC26
////
////  Created by Rodrigo Cont on 13/02/26.
////
//
//import SwiftUI
//
//struct TutorialCardScene: View {
//    let text: String
//    let onNext: () -> Void
//    var dimOpacity: Double = 0.45
//
//    var body: some View {
//        ZStack(alignment: .bottomTrailing) {
//            Color.black.opacity(dimOpacity).ignoresSafeArea()
//
//            TutorialCard(text: text)
//
//            Button(action: onNext) {
//                Image("NextButton")
//            }
//            .padding(28)
//            .shadow(radius: 2, y: 4)
//        }
//    }
//}
