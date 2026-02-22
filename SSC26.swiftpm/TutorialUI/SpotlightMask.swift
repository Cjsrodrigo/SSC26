    //
    //  SpotlightMask.swift
    //  SSC26
    //
    //  Created by Rodrigo Cont on 13/02/26.
    //
import SwiftUI

struct SpotlightMask: View {
    let holes: [CGRect]
    let strokeRect: CGRect?

    var dimOpacity: Double = 0.90
    var cornerRadius: CGFloat = 8
    var holePadding: CGFloat = 0

    var strokeWidth: CGFloat = 3
    var strokeColor: Color = .white

    // ✅ Uneven hole/stroke (ex.: tab)
    var customHole: (rect: CGRect, tl: CGFloat, tr: CGFloat, bl: CGFloat, br: CGFloat)? = nil
    var customStroke: (rect: CGRect, tl: CGFloat, tr: CGFloat, bl: CGFloat, br: CGFloat)? = nil

    var body: some View {
        GeometryReader { proxy in
            let paddedHoles = holes.map { $0.insetBy(dx: -holePadding, dy: -holePadding) }
            let paddedStroke = strokeRect?.insetBy(dx: -holePadding, dy: -holePadding)

            let paddedCustomHole = customHole.map {
                (rect: $0.rect.insetBy(dx: -holePadding, dy: -holePadding),
                 tl: $0.tl, tr: $0.tr, bl: $0.bl, br: $0.br)
            }
            let paddedCustomStroke = customStroke.map {
                (rect: $0.rect.insetBy(dx: -holePadding, dy: -holePadding),
                 tl: $0.tl, tr: $0.tr, bl: $0.bl, br: $0.br)
            }

            ZStack {
                Path { p in
                    p.addRect(CGRect(origin: .zero, size: proxy.size))

                    for r in paddedHoles {
                        p.addRoundedRect(
                            in: r,
                            cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
                        )
                    }

                    if let h = paddedCustomHole {
                        let path = UnevenRoundedRectangle(
                            topLeadingRadius: h.tl,
                            bottomLeadingRadius: h.bl, bottomTrailingRadius: h.br, topTrailingRadius: h.tr
                        ).path(in: h.rect)
                        p.addPath(path)
                    }
                }
                .fill(Color.black.opacity(dimOpacity), style: FillStyle(eoFill: true))

                if let r = paddedStroke {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(strokeColor, lineWidth: strokeWidth)
                        .frame(width: r.width, height: r.height)
                        .position(x: r.midX, y: r.midY)
                }

                if let s = paddedCustomStroke {
                    UnevenRoundedRectangle(
                        topLeadingRadius: s.tl,
                        bottomLeadingRadius: s.bl, bottomTrailingRadius: s.br, topTrailingRadius: s.tr
                    )
                    .stroke(strokeColor, lineWidth: strokeWidth)
                    .frame(width: s.rect.width, height: s.rect.height)
                    .position(x: s.rect.midX, y: s.rect.midY)
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
