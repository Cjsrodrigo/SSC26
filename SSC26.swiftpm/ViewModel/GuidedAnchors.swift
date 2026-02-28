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
    case grid(pageId: Int)
    
    case speakButton
    case messageBox
    case copyButton
    case eraseButton
}

struct GuidedAnchorKey: PreferenceKey {
    static var defaultValue: [GuidedTarget: Anchor<CGRect>] { [:] }
    static func reduce(value: inout [GuidedTarget: Anchor<CGRect>],
                       nextValue: () -> [GuidedTarget: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
