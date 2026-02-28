//
//  AppColors.swift
//  Expresso
//
//  Created by Rodrigo Cont on 23/02/26.
//

import SwiftUI

enum AppColors {
    
    static func background(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#0E2A2E") : Color(hex: "#8CCED7")
    }
    
    static func surface(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#1B3A3F") : .white
    }
    
    static func surfaceAlt(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#173136") : Color(hex: "#E6E6E6")
    }
    
    static func textPrimary(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white : Color.black
    }
    
    static func textOnLightSurface(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white : Color.black    }
    
    static func msgbox(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#CCCCCC") : Color(hex: "#FFFFFF")  }
    
    static func stroke(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#CCCCCC") : Color.black
    }
    
    static func separator(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#CCCCCC").opacity(0.85) : Color.black
    }
    
    static func overlayDim(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.black.opacity(0.55) : Color.black.opacity(0.35)
    }
    
    static func cardShadowOpacity(_ scheme: ColorScheme) -> Double {
        scheme == .dark ? 0.0 : 1.0
    }
    
    static func speakButtonFill(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#612800") : Color(hex: "#FF985C")
    }
    static func tilefill(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(hex: "#2A3739") : Color(hex: "#FFFFFF")
    }
}

