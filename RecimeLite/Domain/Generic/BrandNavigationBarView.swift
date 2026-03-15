//
//  BrandNavigationBarView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import SwiftUI

struct BrandNavigationBarView: View {
    enum Constants {
        static let logoHeight = 22.0
    }

    var body: some View {
        VStack(spacing: 0) {
            Image(.appLogoText)
                .resizable()
                .scaledToFit()
                .frame(height: Constants.logoHeight)
                .foregroundStyle(.accentBlue)
                .padding(.vertical, 16)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.divider)
        }
        .frame(maxWidth: .infinity)
        .background(Color.foregroundPrimary)
    }
}
