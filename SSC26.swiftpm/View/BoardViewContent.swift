//
//  BoardViewContent.swift
//  SSC26
//
//  Created by Rodrigo Cont on 13/02/26.
//

import SwiftUI

struct BoardViewContent: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var flow: AppFlowViewModel
    
    @ObservedObject var vm: BoardViewModel
    
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
    private let sideSize: CGFloat = 85
    
    private let gridSpacing: CGFloat = 22
    private let rowSpacing: CGFloat = 16
    
    private var gridWidth: CGFloat { (tileSize * 6) + (gridSpacing * 5) }
    private var messageBoxWidth: CGFloat { (tileSize * 3) + (gridSpacing * 2) }
    
    private var gridCols: [GridItem] {
        Array(repeating: GridItem(.fixed(tileSize), spacing: gridSpacing), count: 6)
    }
    
    private let tabShape = UnevenRoundedRectangle(
        cornerRadii: .init(topLeading: 15, bottomLeading: 0, bottomTrailing: 0, topTrailing: 15)
    )
    
    var body: some View {
        ZStack(alignment: .top) {
            AppColors.background(scheme).ignoresSafeArea()
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
                                .overlay(tabShape.stroke(Color.black, lineWidth: 1))
                                .shadow(radius: 2 , x: 4)
                                .shadow(radius: 2, x: -4)
                        }
                        .anchorPreference(key: GuidedAnchorKey.self, value: .bounds) {
                            [.tab(pageId: p.id): $0]
                        }
                        .zIndex(isSelected ? 10 : 0)
                    }
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.container, edges: .horizontal)
                .padding(.top, 16)
                
                
                HStack(alignment: .center, spacing: 16) {
                    
                    VStack(alignment: .leading, spacing: rowSpacing) {
                        
                        HStack(spacing: gridSpacing) {
                            
                            Button { vm.speakMessage() } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 30))
                                        .foregroundStyle(AppColors.stroke(scheme))
                                    Text("Speak")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundStyle(AppColors.textOnLightSurface(scheme))
                                }
                                .foregroundStyle(AppColors.textOnLightSurface(scheme))                                .frame(width: tileSize, height: tileSize)
                                .background(AppColors.speakButtonFill(scheme))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 2, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.stroke(scheme), lineWidth: 3)                                )
                            }
                            .anchorPreference(key: GuidedAnchorKey.self, value: .bounds) {
                                [GuidedTarget.speakButton: $0]
                            }
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(AppColors.msgbox(scheme))
                                Text(vm.messageText)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 16)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(width: messageBoxWidth, height: tileSize)
                            .anchorPreference(key: GuidedAnchorKey.self, value: .bounds) {
                                [GuidedTarget.messageBox: $0]
                            }
                            
                            Button { vm.copyMessage() } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: "doc.on.doc")
                                        .font(.system(size: 30))
                                        .foregroundStyle(AppColors.stroke(scheme))
                                    Text("Copy").font(.system(size: 13, weight: .regular))
                                        .foregroundStyle(AppColors.textOnLightSurface(scheme))
                                }
                                .frame(width: tileSize, height: tileSize)
                                .background(AppColors.tilefill(scheme))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 2, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.stroke(scheme), lineWidth: 3)                                )
                            }.anchorPreference(key: GuidedAnchorKey.self, value: .bounds) {
                                [GuidedTarget.copyButton: $0]
                            }
                            
                            VStack(spacing: 6) {
                                Image(systemName: "delete.left")
                                    .font(.system(size: 30))
                                    .foregroundStyle(AppColors.stroke(scheme))
                                Text("Erase").font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(AppColors.textOnLightSurface(scheme))
                            }
                            
                            .frame(width: tileSize, height: tileSize)
                            .background(AppColors.tilefill(scheme))                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 2, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.stroke(scheme), lineWidth: 3)
                            )
                            .foregroundStyle(AppColors.textOnLightSurface(scheme))                            .opacity(erasePressed ? 0.20 : 1.0)
                            .animation(.easeOut(duration: 0.12), value: erasePressed)
                            .gesture(
                                LongPressGesture(minimumDuration: 0.6)
                                    .updating($erasePressed) { _, state, _ in state = true }
                                    .onEnded { _ in vm.clearAll() }
                            )
                            .simultaneousGesture(
                                TapGesture().onEnded { vm.eraseLast() }
                            )
                            .anchorPreference(key: GuidedAnchorKey.self, value: .bounds) {
                                [GuidedTarget.eraseButton: $0]
                            }
                        }
                        .frame(width: gridWidth, alignment: .leading)
                        
                        LazyVGrid(columns: gridCols, spacing: rowSpacing) {
                            ForEach(vm.currentPage.tiles) { tile in
                                Button {
                                    vm.tryTapTile(tile)
                                } label: {
                                    TileView(tile: tile, size: tileSize)
                                    
                                }
                                .anchorPreference(key: GuidedAnchorKey.self, value: .bounds) {
                                    [.tile(pageId: vm.currentPageId, label: tile.label): $0]
                                }
                                .buttonStyle(.plain)
                                
                            }
                        }
                        .anchorPreference(key: GuidedAnchorKey.self, value: .bounds) {
                            [.grid(pageId: vm.currentPageId): $0]
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
                    
                    Rectangle()
                        .fill(AppColors.separator(scheme))                        .frame(width: onePixel, height: leftColumnHeight)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, 8)
                    
                    VStack(spacing: 30) {
                        
                        
                        
                        Button {
                            vm.tryTapSidebarAction {
                                flow.goMainMenu()
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: "house")
                                    .font(.system(size: 30))
                                    .foregroundStyle(AppColors.stroke(scheme))
                                
                                Text("Menu")
                                    .font(.system(size: 12, weight: .regular))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(AppColors.textOnLightSurface(scheme))
                            }
                            .frame(width: sideSize, height: sideSize)
                            .background(AppColors.tilefill(scheme))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 2, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(AppColors.stroke(scheme), lineWidth: 3)
                            )
                        }
                        
                        
                        Button { vm.tryTapSidebarAction {
                            vm.isYesNoPresented = true }} label: {
                                VStack(spacing: 6) {
                                    Image("YesNoBoard")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 57, height: 57)
                                    Text("Yes or no")
                                        .font(.system(size: 12, weight: .regular))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(AppColors.textOnLightSurface(scheme))
                                }
                                .frame(width: sideSize, height: sideSize)
                                .background(AppColors.tilefill(scheme))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 2, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.stroke(scheme), lineWidth: 3)                                )
                            }
                        
                        Button { vm.tryTapSidebarAction {
                            vm.currentPageId = 1}} label: {
                                VStack(spacing: 6) {
                                    Image("BackToPage1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 57, height: 57)
                                    Text("Actions 1")
                                        .font(.system(size: 12, weight: .regular))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(AppColors.textOnLightSurface(scheme))
                                }
                                
                                
                                .frame(width: sideSize, height: sideSize)
                                .background(AppColors.tilefill(scheme))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 2, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.stroke(scheme), lineWidth: 3)                                )
                            }
                    }
                    .foregroundStyle(.black)
                }
                .padding(.leading, 50)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            if vm.isYesNoPresented {
                ZStack {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture { vm.isYesNoPresented = false }
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 22) {
                            Button {
                                vm.tts.speak("yes")
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
                                .background(AppColors.tilefill(scheme))
                                .foregroundStyle(AppColors.textOnLightSurface(scheme))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.green, lineWidth: 3))
                            }
                            
                            Button {
                                vm.tts.speak("no")
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
                                .background(AppColors.tilefill(scheme))
                                .foregroundStyle(AppColors.textOnLightSurface(scheme))                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.red, lineWidth: 3))
                            }
                        }
                        
                        Button("Close") { vm.isYesNoPresented = false }
                            .font(.system(size: 13, weight: .medium))
                            .padding(.top, 6)
                    }
                    .foregroundStyle(AppColors.textOnLightSurface(scheme))                       .padding(22)
                    .background(AppColors.background(scheme))
                    
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
    }
}
