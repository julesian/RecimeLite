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

            currentView
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )

            bottomBar
        }
    }

    @ViewBuilder
    private var currentView: some View {
        switch selectedTab {
        case .recipes: RecipesView()
        case .plan: PlanView()
        case .grocery: GroceryView()
        case .more: MoreView()
        }
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
                    .font(.caption)
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
