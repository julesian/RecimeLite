//
//  AppRootView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//


import SwiftUI

struct AppRootView: View {
    @StateObject var viewModel: AppRootViewModel
    
    var body: some View {
        Group {
            if viewModel.isSplashFinished {
                HomeView()
            } else {
                SplashView()
            }
        }
        .onAppear {
            viewModel.startSplash()
        }
        .animation(.easeInOut, value: viewModel.isSplashFinished)
    }
}

#Preview {
    AppRootView(viewModel: AppRootViewModel())
}
