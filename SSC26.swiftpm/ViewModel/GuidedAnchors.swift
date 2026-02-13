//
//  GuidedAnchors.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI

enum GuidedTarget: Hashable {
    case tile(pageId: Int, label: String)
    case tab(pageId: Int)        

    case speakButton
}

struct GuidedAnchorKey: PreferenceKey {
    static var defaultValue: [GuidedTarget: Anchor<CGRect>] { [:] } // computed (Swift 6 safe)
    static func reduce(value: inout [GuidedTarget: Anchor<CGRect>],
                       nextValue: () -> [GuidedTarget: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
