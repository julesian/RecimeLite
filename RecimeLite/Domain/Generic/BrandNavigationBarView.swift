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
        static let sideWidth = 44.0
    }

    let trailingSystemImage: String?
    let trailingAction: (() -> Void)?

    init(
        trailingSystemImage: String? = nil,
        trailingAction: (() -> Void)? = nil
    ) {
        self.trailingSystemImage = trailingSystemImage
        self.trailingAction = trailingAction
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Color.clear
                    .frame(width: Constants.sideWidth, height: Constants.sideWidth)

                Spacer()

                Image(.appLogoText)
                    .resizable()
                    .scaledToFit()
                    .frame(height: Constants.logoHeight)
                    .foregroundStyle(.accentBlue)

                Spacer()

                trailingButton
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.divider)
        }
        .frame(maxWidth: .infinity)
        .background(Color.foregroundPrimary)
    }

    @ViewBuilder
    private var trailingButton: some View {
        if let trailingSystemImage, let trailingAction {
            Button(action: trailingAction) {
                Image(systemName: trailingSystemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.textPrimary)
                    .frame(width: Constants.sideWidth, height: Constants.sideWidth)
            }
            .buttonStyle(.plain)
        } else {
            Color.clear
                .frame(width: Constants.sideWidth, height: Constants.sideWidth)
        }
    }
}
