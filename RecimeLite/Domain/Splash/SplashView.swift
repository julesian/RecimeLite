//
//  SplashView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//


import SwiftUI

struct SplashView: View {
    
    enum Constants {
        static let logoSize = 140.0
    }
    
    var body: some View {
        ZStack {
            Color.backgroundSplash
                .ignoresSafeArea()
            
            Image(.appLogo)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(
                    width: Constants.logoSize,
                    height: Constants.logoSize
                )
                .foregroundStyle(Color.accentYellow)
        }
    }
}

#Preview("Light Mode") {
    SplashView()
}

#Preview("Dark Mode") {
    SplashView()
        .preferredColorScheme(.dark)
}
