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
        NavigationView {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()

                VStack(spacing: 12) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .primaryTextStyle()

                    Text("Coming Soon")
                        .font(.body)
                        .secondaryTextStyle()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 24)
                .background(Color.backgroundPrimary)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.foregroundPrimary, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        }
    }
}
