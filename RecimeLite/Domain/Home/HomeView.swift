//
//  HomeView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .recipes

    enum Constants {
        static let iconSize = 24.0
        static let itemSpacing = 4.0
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundPrimary
                .ignoresSafeArea()

            contentView
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )

            bottomBar
        }
    }

    private var contentView: some View {
        ZStack {
            tabContent(.recipes) {
                RecipesView()
            }

            tabContent(.plan) {
                PlanView()
            }

            tabContent(.grocery) {
                GroceryView()
            }

            tabContent(.more) {
                MoreView()
            }
        }
    }

    private func tabContent<Content: View>(
        _ tab: Tab,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .opacity(selectedTab == tab ? 1 : 0)
            .allowsHitTesting(selectedTab == tab)
            .accessibilityHidden(selectedTab != tab)
    }

    private var bottomBar: some View {
        HStack(spacing: Constants.itemSpacing) {
            ForEach(Tab.allCases) { tab in
                itemView(from: tab)
            }
        }
        .padding(8)
        .background(Color.foregroundPrimary)
        .clipShape(Capsule())
        .shadow(color: .shadow, radius: 14, y: 6)
    }
    
    private func itemView(from tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.iconName)
                    .font(.system(size: Constants.iconSize))

                Text(tab.title)
                    .bottomBarTextStyle()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .foregroundStyle(tab == selectedTab ? .accentOrange : .iconTintSecondary)
        }
        .buttonStyle(.plain)
    }
}

private extension HomeView {
    enum Tab: String, CaseIterable, Identifiable {
        case recipes
        case plan
        case grocery
        case more

        var id: String { rawValue }

        var title: String {
            switch self {
            case .recipes: "Recipes"
            case .plan: "Plan"
            case .grocery: "Grocery"
            case .more: "More"
            }
        }

        var iconName: String {
            switch self {
            case .recipes: "book"
            case .plan: "calendar"
            case .grocery: "cart"
            case .more: "ellipsis.circle"
            }
        }
    }
}
