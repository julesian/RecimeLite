import SwiftUI

struct RecipesNavigationBarView: View {
    enum Constants {
        static let searchFieldHeight = 38.0
        static let searchIconSize = 15.0
        static let filterIconSize = 15.0
        static let logoHeight = 26.0
        static let horizontalPadding = 12.0
        static let verticalPadding = 16.0
        static let animationDuration = 0.28
        static let itemSpacing = 8.0
        static let filterButtonWidth = searchFieldHeight
        static let logoOffsetX = -24.0
        static let startupOffsetY = 8.0
        static let startupAnimationDelay = 0.08
        static let startupAnimationDuration = 0.42
    }

    @Binding var searchText: String
    @Binding var isSearchExpanded: Bool
    @State private var hasAnimatedHeader = false
    let hasActiveFilters: Bool

    let onCollapseSearch: () -> Void
    let onFilterTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack {
                    recimeImageView
                    searchView(currentWidth: geometry.size.width)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: Constants.searchFieldHeight)
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding)
            
            Divider()
                .foregroundStyle(.divider)
        }
        .background(Color.foregroundPrimary)
        .animation(.easeInOut(duration: Constants.animationDuration), value: isSearchExpanded)
        .onAppear(perform: animateHeaderTransition)
    }
    
    private var recimeImageView: some View {
        RecimeImageView(height: Constants.logoHeight)
            .frame(maxWidth: .infinity, alignment: .center)
            .opacity(isSearchExpanded ? 0 : headerContentOpacity)
            .offset(x: isSearchExpanded ? Constants.logoOffsetX : 0)
            .offset(y: headerContentVerticalOffset)
    }
    
    private func searchView(currentWidth: CGFloat) -> some View {
        HStack(spacing: Constants.itemSpacing) {
            filterButton
                .frame(width: filterButtonWidth)
                .opacity(isSearchExpanded ? 1 : 0)

            searchContainer
                .frame(
                    width: searchWidth(in: currentWidth),
                    alignment: .trailing
                )
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private var searchContainer: some View {
        ExpandableInputCapsuleView(
            text: $searchText,
            isExpanded: $isSearchExpanded,
            placeholder: "Search recipes",
            collapsedImage: "magnifyingglass",
            inputContextImage: "magnifyingglass",
            inputActionImage: "xmark",
            height: Constants.searchFieldHeight,
            iconSize: Constants.searchIconSize,
            hidesActionWhenExpandedAndEmpty: true,
            onAction: trailingButtonTapped
        )
        .opacity(headerContentOpacity)
        .offset(y: headerContentVerticalOffset)
    }

    private var filterButtonWidth: CGFloat {
        isSearchExpanded ? Constants.filterButtonWidth : 0
    }

    private func searchWidth(in availableWidth: CGFloat) -> CGFloat {
        if isSearchExpanded {
            return max(
                Constants.searchFieldHeight,
                availableWidth - filterButtonWidth - Constants.itemSpacing
            )
        }

        return Constants.searchFieldHeight
    }

    private var filterButton: some View {
        CircularIconButtonView(
            systemImage: "line.3.horizontal.decrease",
            size: Constants.searchFieldHeight,
            iconSize: Constants.filterIconSize,
            style: hasActiveFilters ? .accent : .standard,
            action: onFilterTap
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

    private var headerContentOpacity: Double {
        hasAnimatedHeader ? 1 : 0
    }

    private var headerContentVerticalOffset: CGFloat {
        hasAnimatedHeader ? 0 : Constants.startupOffsetY
    }

    private func animateHeaderTransition() {
        guard !hasAnimatedHeader else { return }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(Constants.startupAnimationDelay))

            withAnimation(.easeInOut(duration: Constants.startupAnimationDuration)) {
                hasAnimatedHeader = true
            }
        }
    }
}
