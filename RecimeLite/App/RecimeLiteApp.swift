//
//  RecimeLiteApp.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import SwiftUI

@main
struct RecimeLiteApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView(viewModel: AppRootViewModel())
        }
    }
}
