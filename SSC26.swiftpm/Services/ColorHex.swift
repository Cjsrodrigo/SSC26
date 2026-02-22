//
//  ColorHex.swift
//  SSC26
//
//  Created by Rodrigo Cont on 22/02/26.
//

import SwiftUI

extension Color {
    /// Aceita "#RRGGBB", "RRGGBB", "#AARRGGBB", "AARRGGBB", "#RGB", "RGB"
    init(hex: String) {
        let cleaned = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()

        func hexVal(_ c: Character) -> UInt8 {
            switch c {
            case "0"..."9": return UInt8(c.unicodeScalars.first!.value - Character("0").unicodeScalars.first!.value)
            case "A"..."F": return UInt8(c.unicodeScalars.first!.value - Character("A").unicodeScalars.first!.value + 10)
            default: return 0
            }
        }

        let r, g, b, a: UInt8

        switch cleaned.count {
        case 3: // RGB (12-bit)
            let chars = Array(cleaned)
            r = hexVal(chars[0]) * 17
            g = hexVal(chars[1]) * 17
            b = hexVal(chars[2]) * 17
            a = 255

        case 6: // RRGGBB
            let chars = Array(cleaned)
            r = hexVal(chars[0]) * 16 + hexVal(chars[1])
            g = hexVal(chars[2]) * 16 + hexVal(chars[3])
            b = hexVal(chars[4]) * 16 + hexVal(chars[5])
            a = 255

        case 8: // AARRGGBB
            let chars = Array(cleaned)
            a = hexVal(chars[0]) * 16 + hexVal(chars[1])
            r = hexVal(chars[2]) * 16 + hexVal(chars[3])
            g = hexVal(chars[4]) * 16 + hexVal(chars[5])
            b = hexVal(chars[6]) * 16 + hexVal(chars[7])

        default:
            // fallback seguro
            r = 0; g = 0; b = 0; a = 255
        }

        self.init(
            .sRGB,
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0,
            opacity: Double(a) / 255.0
        )
    }
}
