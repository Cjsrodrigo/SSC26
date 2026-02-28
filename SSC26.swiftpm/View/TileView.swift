//
//  TileView.swift
//  SSC26
//
//  Created by Rodrigo Cont on 09/02/26.
//

import SwiftUI

struct TileView: View {
    let tile: BookTile
    let size: CGFloat
    
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack(spacing: 6) {
            
            Image(tile.iconName, bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(height: size * 0.6)
            
            Text(tile.label)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(AppColors.textOnLightSurface(scheme))                    .lineLimit(1)
        }
        .frame(width: size, height: size)
        
        .background(AppColors.tilefill(scheme))            .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(tile.borderColor, lineWidth: 6)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 2 , y: 4 )
    }
}
