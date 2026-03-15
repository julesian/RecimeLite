import SwiftUI

struct RecipesNavigationBarView: View {
    enum Constants {
        static let searchFieldHeight = 44.0
        static let searchIconSize = 16.0
        static let logoHeight = 26.0
        static let horizontalPadding = 12.0
        static let verticalPadding = 16.0
        static let animationDuration = 0.28
        static let brandLogoOffsetX = -32.0
    }

    @Binding var searchText: String
    @Binding var isSearchExpanded: Bool

    let onCollapseSearch: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .trailing) {
                RecimeImageView(height: Constants.logoHeight)
                    .opacity(isSearchExpanded ? 0 : 1)
                    .offset(x: isSearchExpanded ? Constants.brandLogoOffsetX : 0)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .clipped()

                searchContainer
                    .frame(maxWidth: isSearchExpanded ? .infinity : Constants.searchFieldHeight)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding)
            
            Divider()
                .foregroundStyle(.divider)
        }
        .background(Color.foregroundPrimary)
        .animation(.easeInOut(duration: Constants.animationDuration), value: isSearchExpanded)
    }

    private var searchContainer: some View {
        ExpandableInputCapsuleView(
            text: $searchText,
            isExpanded: $isSearchExpanded,
            placeholder: "Search recipes",
            collapsedSystemImage: "magnifyingglass",
            expandedLeadingSystemImage: "magnifyingglass",
            actionSystemImage: "xmark",
            height: Constants.searchFieldHeight,
            iconSize: Constants.searchIconSize,
            hidesActionWhenExpandedAndEmpty: true,
            onAction: trailingButtonTapped
        )
    }

    private func trailingButtonTapped() {
        if isSearchExpanded {
            if !searchText.isEmpty {
                onCollapseSearch()
            }
        } else {
            isSearchExpanded = true
        }
    }
}
