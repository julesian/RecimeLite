//
//  AppRootViewModel.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//


import Foundation
import Combine

final class AppRootViewModel: ObservableObject {
    @Published var isSplashFinished = false
    
    enum Constants {
        static let displayDuration: TimeInterval = 1.8
    }
    
    func startSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.displayDuration) { [weak self] in
            self?.isSplashFinished = true
        }
    }
}
