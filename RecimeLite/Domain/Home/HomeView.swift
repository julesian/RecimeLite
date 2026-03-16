//
//  HomeView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .recipes
    @State private var hasAnimatedBottomBar = false

    enum Constants {
        static let iconSize = 24.0
        static let itemSpacing = 4.0
        static let startupSpacingMultiplier = 2.0
        static let bottomBarAnimationDelay = 0.6
        static let bottomBarAnimationDuration = 0.42
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

            tabContent(.about) {
                AboutView()
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
        HStack(spacing: bottomBarSpacing) {
            ForEach(Tab.allCases) { tab in
                itemView(from: tab)
            }
        }
        .padding(8)
        .background(Color.foregroundPrimary)
        .clipShape(Capsule())
        .shadow(color: .shadow, radius: 14, y: 6)
        .opacity(hasAnimatedBottomBar ? 1 : 0)
        .onAppear(perform: animateBottomBarTransition)
    }

    private var bottomBarSpacing: Double {
        hasAnimatedBottomBar
            ? Constants.itemSpacing
            : Constants.itemSpacing * Constants.startupSpacingMultiplier
    }
    
    private func itemView(from tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.iconName)
                    .font(.system(size: Constants.iconSize))

                Text(tab.title)
                    .bottomBarTextStyle(isSelected: tab == selectedTab)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .foregroundStyle(tab == selectedTab ? .accentOrange : .iconTintSecondary)
        }
        .buttonStyle(.plain)
    }

    private func animateBottomBarTransition() {
        guard !hasAnimatedBottomBar else { return }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(Constants.bottomBarAnimationDelay))

            withAnimation(.easeInOut(duration: Constants.bottomBarAnimationDuration)) {
                hasAnimatedBottomBar = true
            }
        }
    }
}

private extension HomeView {
    enum Tab: String, CaseIterable, Identifiable {
        case recipes
        case plan
        case grocery
        case about

        var id: String { rawValue }

        var title: String {
            switch self {
            case .recipes: "Recipes"
            case .plan: "Plan"
            case .grocery: "Grocery"
            case .about: "About"
            }
        }

        var iconName: String {
            switch self {
            case .recipes: "book"
            case .plan: "calendar"
            case .grocery: "cart"
            case .about: "person.circle"
            }
        }
    }
}
