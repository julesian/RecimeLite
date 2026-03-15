import SwiftUI

struct RecipesNavigationBarView: View {
    enum Constants {
        static let searchFieldHeight = 44.0
        static let searchIconSize = 16.0
        static let logoHeight = 26.0
        static let horizontalPadding = 12.0
        static let verticalPadding = 16.0
        static let itemSpacing = 12.0
        static let animationDuration = 0.28
        static let brandLogoOffsetX = -32.0
    }

    @Binding var searchText: String
    @Binding var isSearchExpanded: Bool

    let onCollapseSearch: () -> Void

    @FocusState private var isSearchFieldFocused: Bool

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
        .animation(.easeInOut(duration: Constants.animationDuration), value: searchText.isEmpty)
        .onChange(of: isSearchExpanded) { _, isExpanded in
            isSearchFieldFocused = isExpanded
        }
    }

    private var searchContainer: some View {
        HStack(spacing: 10) {
            if isSearchExpanded {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.textSecondary)

                TextField("Search recipes", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .primaryTextStyle()
                    .focused($isSearchFieldFocused)
            }

            Button(action: trailingButtonTapped) {
                Image(systemName: trailingButtonSystemImage)
                    .font(.system(size: Constants.searchIconSize, weight: .semibold))
                    .foregroundStyle(.textPrimary)
                    .frame(width: Constants.searchFieldHeight, height: Constants.searchFieldHeight)
                    .background(Color.backgroundPrimary)
                    .clipShape(Circle())
                    .opacity(trailingButtonOpacity)
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, isSearchExpanded ? 14 : 0)
        .padding(.trailing, isSearchExpanded ? 6 : 0)
        .frame(height: Constants.searchFieldHeight)
        .background(Color.backgroundPrimary)
        .clipShape(Capsule())
    }

    private var trailingButtonSystemImage: String {
        if !searchText.isEmpty {
            return "xmark"
        }

        return "magnifyingglass"
    }

    private var trailingButtonOpacity: Double {
        if isSearchExpanded, searchText.isEmpty {
            return 0
        }

        return 1
    }

    private func trailingButtonTapped() {
        if isSearchExpanded {
            if searchText.isEmpty {
                isSearchFieldFocused = true
            } else {
                onCollapseSearch()
            }
        } else {
            isSearchExpanded = true
            isSearchFieldFocused = true
        }
    }
}
