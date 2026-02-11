//
//  BoardView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//

import SwiftUI

struct BoardView: View {
    @StateObject private var vm = BoardViewModel(pages: BoardDefinition.makePages())
    
    @GestureState private var erasePressed = false
    
    @State private var leftColumnHeight: CGFloat = 0
    @Environment(\.displayScale) private var displayScale
    private var onePixel: CGFloat { 2 / displayScale }

    private struct LeftHeightKey: PreferenceKey {
        static var defaultValue: CGFloat { 0 }

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }



    private let tileSize: CGFloat = 85
    private let sideSize: CGFloat = 90
    
    private let gridSpacing: CGFloat = 22
    private let rowSpacing: CGFloat = 16

    
    private var gridWidth: CGFloat {
        (tileSize * 6) + (gridSpacing * 5)
    }

    private var messageBoxWidth: CGFloat {
        
        (tileSize * 3) + (gridSpacing * 2)
    }

    private var gridCols: [GridItem] {
        Array(repeating: GridItem(.fixed(tileSize), spacing: gridSpacing), count: 6)
    }

    let tabShape = UnevenRoundedRectangle(
        cornerRadii: .init(
            topLeading: 15,
            bottomLeading: 0,
            bottomTrailing: 0,
            topTrailing: 15
        )
    )
    
    var body: some View {
        ZStack (alignment: .top){
            Color(red: 0.60, green: 0.83, blue: 0.86).ignoresSafeArea()

            VStack(spacing: 12) {
                

                HStack(spacing: -5) {
                    ForEach(vm.pages) { p in
                        let isSelected = (vm.currentPageId == p.id)

                        Button {
                            vm.currentPageId = p.id
                        } label: {
                           

                            Text(p.title)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 37.5)
                                .background(p.tabColor)
                                .clipShape(tabShape)
                                .overlay(
                                    tabShape.stroke(Color.black, lineWidth: 1)
                                )
                                .shadow(radius: 2, x: 4)
                                .shadow(radius: 2, x: -4)

                        }
                        .zIndex(isSelected ? 10 : 0)

                    }
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.container, edges: .horizontal)
                .padding(.top, 16)


                HStack(alignment: .center, spacing: 16) {

                    // COLUNA ESQUERDA
                    VStack(alignment: .leading, spacing: rowSpacing) {

                        HStack(spacing: gridSpacing) {

                            Button { vm.speakMessage() } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 30))
                                    Text("Speak").font(.system(size: 13, weight: .regular))
                                }
                                .foregroundStyle(.black)
                                .frame(width: tileSize, height: tileSize)
                                .background(Color.orange.opacity(0.75))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 2, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 3)
                                )
                            }

                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                Text(vm.messageText)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 16)
                                    .lineLimit(2)
                            }
                            .frame(width: messageBoxWidth, height: tileSize)

                            Button { vm.copyMessage() } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: "doc.on.doc")
                                        .font(.system(size: 30))
                                    Text("Copy").font(.system(size: 13, weight: .regular))
                                }
                                .foregroundStyle(.black)
                                .frame(width: tileSize, height: tileSize)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 2, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 3)
                                )
                            }

                            VStack(spacing: 6) {
                                Image(systemName: "delete.left")
                                    .font(.system(size: 30))
                                Text("Erase").font(.system(size: 13, weight: .regular))
                            }
                            .frame(width: tileSize, height: tileSize)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 2, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                            .foregroundStyle(.black)
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .opacity(erasePressed ? 0.20 : 1.0)
                            .animation(.easeOut(duration: 0.12), value: erasePressed)
                            .gesture(
                                LongPressGesture(minimumDuration: 0.6)
                                    .updating($erasePressed) { _, state, _ in state = true }
                                    .onEnded { _ in vm.clearAll() }
                            )
                            .simultaneousGesture(
                                TapGesture().onEnded { vm.eraseLast() }
                            )
                        }
                        .frame(width: gridWidth, alignment: .leading)

                        // Grid 2x6
                        LazyVGrid(columns: gridCols, spacing: rowSpacing) {
                            ForEach(vm.currentPage.tiles) { tile in
                                Button {
                                    vm.tapTile(tile)
                                } label: {
                                    TileView(tile: tile, size: tileSize)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(width: gridWidth, alignment: .leading)
                        .padding(.top, 30)

                        
                    }
                    
                    .background(
                        GeometryReader { proxy in
                            Color.clear.preference(key: LeftHeightKey.self, value: proxy.size.height)
                        }
                    )
                    .onPreferenceChange(LeftHeightKey.self) { leftColumnHeight = $0 }

                  //  Spacer()

                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: onePixel, height: leftColumnHeight)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, 8)
                //    Spacer()
                    
                    VStack(spacing: 40) {
                        Button { vm.currentPageId = 1 } label: {
                            VStack(spacing: 6) {
                                Image("BackToPage1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 62, height: 62)
                                Text("Back to page 1")
                                    .font(.system(size: 12, weight: .regular))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: sideSize, height: sideSize)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 2, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                        }

                        Button { vm.isYesNoPresented = true } label: {
                            VStack(spacing: 6) {
                                Image("YesNoBoard")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 62, height: 62)
                                Text("Yes no board")
                                    .font(.system(size: 12, weight: .regular))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: sideSize, height: sideSize)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 2, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                        }
                    }
                    .foregroundStyle(.black)
                }
                .padding(.leading, 50)



                Spacer()
                 
            }    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)


            if vm.isYesNoPresented {
                ZStack {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture { vm.isYesNoPresented = false }

                    VStack(spacing: 16) {

                        HStack(spacing: 22) {
                            Button {
                                vm.speech.speak("yes")
                                vm.tokens.append("yes")
                                vm.isYesNoPresented = false
                            } label: {
                                VStack(spacing: 8) {
                                    Image("Yes")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                    Text("YES")
                                        .font(.system(size: 17, weight: .regular))
                                }
                                .frame(width: 200, height: 200)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.green, lineWidth: 3)
                                )
                            }

                            Button {
                                vm.speech.speak("no")
                                vm.tokens.append("no")
                                vm.isYesNoPresented = false
                            } label: {
                                VStack(spacing: 8) {
                                    Image("No")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                    Text("NO")
                                        .font(.system(size: 17, weight: .regular))
                                }
                                .frame(width: 200, height: 200)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.red, lineWidth: 3)
                                )
                            }
                        }

                        Button("Close") { vm.isYesNoPresented = false }
                            .font(.system(size: 13, weight: .regular))
                            .padding(.top, 6)
                    }
                    .foregroundStyle(.black)
                    .padding(22)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
    
    }
}

#if canImport(SwiftUI)
import SwiftUI
#endif
#if swift(>=5.9)
@available(iOS 17.0, *)
#Preview(traits: .landscapeRight) {
    BoardView()
}
#endif

// Fallback preview for earlier iOS versions or toolchains without the #Preview macro
#if !compiler(>=5.9) || !canImport(SwiftUI)
// No preview support
#else
#if !os(watchOS)
struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
#endif
#endif

