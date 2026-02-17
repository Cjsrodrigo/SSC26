//
//  SpotlightMask.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI

struct SpotlightMask: View {
    let holes: [CGRect]          // buracos (tile atual + messageBox etc.)
    let strokeRect: CGRect?      // ✅ agora é opcional

    var dimOpacity: Double = 0.90
    var cornerRadius: CGFloat = 8
    var holePadding: CGFloat = 0

    var strokeWidth: CGFloat = 3
    var strokeColor: Color = .white

    var body: some View {
        GeometryReader { proxy in
            let paddedHoles = holes.map { $0.insetBy(dx: -holePadding, dy: -holePadding) }
            let paddedStroke = strokeRect?.insetBy(dx: -holePadding, dy: -holePadding)

            ZStack {
                Path { p in
                    p.addRect(CGRect(origin: .zero, size: proxy.size))
                    for r in paddedHoles {
                        p.addRoundedRect(
                            in: r,
                            cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
                        )
                    }
                }
                .fill(Color.black.opacity(dimOpacity), style: FillStyle(eoFill: true))

                // ✅ só desenha o stroke quando existir um alvo válido
                if let r = paddedStroke {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(strokeColor, lineWidth: strokeWidth)
                        .frame(width: r.width, height: r.height)
                        .position(x: r.midX, y: r.midY)
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
