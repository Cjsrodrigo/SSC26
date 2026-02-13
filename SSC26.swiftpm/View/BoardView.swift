//
//  BoardView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//

import SwiftUI

struct BoardView: View {
    @StateObject private var vm = BoardViewModel(pages: BoardDefinition.makePages())

    var body: some View {
        BoardViewContent(vm: vm)
    }
}

#if swift(>=5.9)
@available(iOS 17.0, *)
#Preview(traits: .landscapeRight) {
    BoardView()
}
#endif
