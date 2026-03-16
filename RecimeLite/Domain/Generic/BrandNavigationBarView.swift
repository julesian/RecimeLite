//
//  BrandNavigationBarView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import SwiftUI

struct BrandNavigationBarView: View {
    enum Constants {
        static let sideWidth = 44.0
        static let horizontalPadding = 12.0
        static let verticalPadding = 16.0
    }

    let title: String?
    let showsTitle: Bool

    init(
        title: String? = nil,
        showsTitle: Bool = false
    ) {
        self.title = title
        self.showsTitle = showsTitle
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Color.clear
                    .frame(width: Constants.sideWidth, height: Constants.sideWidth)

                Spacer()

                headerTitleView

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

    @ViewBuilder
    private var headerTitleView: some View {
        if let title {
            BrandTitleSwapView(
                title: title,
                showsTitle: showsTitle
            )
        } else {
            RecimeImageView()
        }
    }
}

#Preview {
    BrandNavigationBarView()
        .background(Color.backgroundPrimary)
}
