//
//  ComingSoonView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import SwiftUI

struct ComingSoonView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            BrandNavigationBarView()

            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()

                VStack(spacing: 4) {
                    Text(title)
                        .primaryTextStyle()

                    Text("Coming Soon")
                        .secondaryTextStyle()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 24)
            }
        }
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    ComingSoonView(title: "Plan")
}
