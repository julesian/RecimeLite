//
//  BrandNavigationBarView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import SwiftUI

struct BrandNavigationBarView: View {
    enum Constants {
        static let logoHeight = 26.0
        static let sideWidth = 44.0
        static let horizontalPadding = 12.0
        static let verticalPadding = 16.0
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Color.clear
                    .frame(width: Constants.sideWidth, height: Constants.sideWidth)

                Spacer()

                RecimeImageView(height: Constants.logoHeight)

                Spacer()

                Color.clear
                    .frame(width: Constants.sideWidth, height: Constants.sideWidth)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.divider)
        }
        .frame(maxWidth: .infinity)
        .background(Color.foregroundPrimary)
    }
}

#Preview {
    BrandNavigationBarView()
        .background(Color.backgroundPrimary)
}
