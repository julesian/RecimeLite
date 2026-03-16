//
//  SplashView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//


import SwiftUI
import Lottie

struct SplashView: View {
    enum Constants {
        static let animationFileName = "recime_splash_intro"
        static let animationWidth = 194.0
        static let animationHeight = 194.0
        static let animationStartDelay = 0.6
        static let safeAreaOffsetMultiplier = 0.28
        static let maxUpwardOffset = 14.0
    }

    @State private var shouldPlayAnimation = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.backgroundSplash
                    .ignoresSafeArea()

                LottieAnimationView(
                    fileName: Constants.animationFileName,
                    loopMode: .playOnce,
                    shouldPlay: shouldPlayAnimation
                )
                .frame(
                    width: Constants.animationWidth,
                    height: Constants.animationHeight
                )
                .offset(y: logoOffsetY(for: geometry))
            }
        }
        .task {
            guard !shouldPlayAnimation else { return }

            try? await Task.sleep(
                for: .seconds(Constants.animationStartDelay)
            )
            shouldPlayAnimation = true
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
