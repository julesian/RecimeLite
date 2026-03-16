//
//  RecipesView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import SwiftUI

struct RecipesView: View {
    @StateObject private var viewModel: RecipesViewModel
    @State private var navigationPath = NavigationPath()
    @State private var isSearchVisible = false
    @State private var isFiltersPresented = false
    @State private var searchText = ""
    @State private var activeSearchText = ""
    @State private var filters = RecipesFilter()

    enum Constants {
        static let searchDebounceNanoseconds: UInt64 = 350_000_000
        static let bottomContentInset = 140.0
        static let searchCollapseAnimationDuration = 0.28
    }
    
    init(viewModel: RecipesViewModel = RecipesView.makeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                navigationBar

                contentView
            }
            .background(Color.backgroundPrimary)
            .sheet(isPresented: $isFiltersPresented) {
                RecipesFilterSheetView(
                    filters: filters,
                    onClose: {
                        isFiltersPresented = false
                    },
                    onApply: applyFilters
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(
                    viewModel: RecipeDetailViewModel(recipe: recipe)
                )
            }
        }
    }
    
    private var navigationBar: some View {
        RecipesNavigationBarView(
            searchText: $searchText,
            isSearchExpanded: $isSearchVisible,
            hasActiveFilters: filters.hasActiveFilters,
            onCollapseSearch: closeSearch,
            onClearSearch: clearSearch,
            onFilterTap: openFilters
        )
    }
    
    private var contentView: some View {
        Group {
            if viewModel.isLoading,
               viewModel.recipes.isEmpty
            {
                progressView
            } else if
                let message = viewModel.errorMessage,
                viewModel.recipes.isEmpty
            {
                contentUnavailableView(errorMessage: message)
            } else {
                listView
            }
        }
        .task {
            await viewModel.loadRecipes()
        }
        .task(id: searchText) {
            guard isSearchVisible else { return }

            try? await Task.sleep(nanoseconds: Constants.searchDebounceNanoseconds)
            guard !Task.isCancelled else { return }

            activeSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            await viewModel.searchRecipes(
                query: searchText,
                filters: filters
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            dismissKeyboard()

            guard isSearchVisible else { return }
            guard !hasSearchInput else { return }

            isSearchVisible = false
        }
    }
    
    private var progressView: some View {
        skeletonListView
    }
    
    private func contentUnavailableView(errorMessage: String) -> some View {
        ContentUnavailableView(
            "Unable to Load Recipes",
            systemImage: "exclamationmark.triangle",
            description: Text(errorMessage)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var listView: some View {
        recipeListView(displayedRecipes)
            .refreshable {
                if isSearchVisible,
                   !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                {
                    await viewModel.searchRecipes(
                        query: searchText,
                        filters: filters
                    )
                } else if filters.hasActiveFilters {
                    await viewModel.searchRecipes(
                        query: searchText,
                        filters: filters
                    )
                } else {
                    await viewModel.loadRecipes()
                }
            }
    }

    private var displayedRecipes: [Recipe] {
        let trimmedQuery = activeSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedQuery.isEmpty && !filters.hasActiveFilters
            ? viewModel.recipes
            : viewModel.searchedRecipes
    }

    private var hasSearchInput: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var skeletonListView: some View {
        recipeListView(Recipe.skeletonSamples)
            .redacted(reason: .placeholder)
            .allowsHitTesting(false)
    }

    private func recipeListView(_ recipes: [Recipe]) -> some View {
        List(recipes) { recipe in
            Button {
                navigationPath.append(recipe)
            } label: {
                recipeItemView(recipe)
            }
            .buttonStyle(.plain)
            .listRowBackground(Color.backgroundPrimary)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary)
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: Constants.bottomContentInset)
        }
    }
    
    func recipeItemView(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(recipe.title)
                    .primaryTextStyle()

                Spacer()

                if recipe.isVegetarian {
                    Text("Vegetarian")
                        .capsuleTextStyle(
                            foregroundColor: .foregroundPrimary,
                            backgroundColor: .accentGreen
                        )
                }
            }

            Text(recipe.description)
                .secondaryTextStyle()

            Text(recipe.servingsText)
                .teritaryTextStyle()
        }
        .padding(16)
        .background(Color.foregroundPrimary)
    }

    private func closeSearch() {
        Task {
            await MainActor.run {
                dismissKeyboard()
                withAnimation(.easeInOut(duration: Constants.searchCollapseAnimationDuration)) {
                    isSearchVisible = false
                }
            }

            try? await Task.sleep(
                for: .seconds(Constants.searchCollapseAnimationDuration)
            )

            await MainActor.run {
                searchText = ""
                activeSearchText = ""
            }

            await viewModel.loadRecipes()
        }
    }

    private func clearSearch() {
        searchText = ""
        activeSearchText = ""

        Task {
            if filters.hasActiveFilters {
                await viewModel.searchRecipes(
                    query: "",
                    filters: filters
                )
            } else {
                await viewModel.loadRecipes()
            }
        }
    }

    private func openFilters() {
        isFiltersPresented = true
    }

    private func applyFilters(_ filters: RecipesFilter) {
        self.filters = filters
        isFiltersPresented = false

        Task {
            if filters.hasActiveFilters
                || !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            {
                activeSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                await viewModel.searchRecipes(
                    query: searchText,
                    filters: filters
                )
            } else {
                await viewModel.loadRecipes()
            }
        }
    }
}

private extension RecipesView {
    // TODO: Proper DI
    static func makeViewModel() -> RecipesViewModel {
        let networkClient = NetworkClient()
        let service = RecipeService(networkClient: networkClient)
        let repository = RecipeRepository(recipeService: service)
        let fetchUseCase = FetchRecipesUseCase(recipeRepository: repository)
        let searchUseCase = SearchRecipesUseCase(recipeRepository: repository)

        return RecipesViewModel(
            fetchRecipesUseCase: fetchUseCase,
            searchRecipesUseCase: searchUseCase
        )
    }
}

#Preview {
    RecipesView()
}
