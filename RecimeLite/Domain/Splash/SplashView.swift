//
//  SplashView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//


import SwiftUI

struct SplashView: View {
    
    enum Constants {
        static let logoWidth = 105.0
        static let logoHeight = 85.0
        static let safeAreaOffsetMultiplier = 0.28
        static let maxUpwardOffset = 14.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.backgroundSplash
                    .ignoresSafeArea()
                
                Image(.appLogoSplash)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: Constants.logoWidth,
                        height: Constants.logoHeight
                    )
                    .offset(y: logoOffsetY(for: geometry))
            }
        }
    }
    
    private func logoOffsetY(for geometry: GeometryProxy) -> CGFloat {
        let adaptiveOffset = geometry.safeAreaInsets.top * Constants.safeAreaOffsetMultiplier
        return -min(adaptiveOffset, Constants.maxUpwardOffset)
    }
}

#Preview("Light Mode") {
    SplashView()
}

#Preview("Dark Mode") {
    SplashView()
        .preferredColorScheme(.dark)
}
