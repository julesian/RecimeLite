//
//  RecipesView.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import SwiftUI

struct RecipesView: View {
    @StateObject private var viewModel: RecipesViewModel
    
    init(viewModel: RecipesViewModel = RecipesView.makeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            BrandNavigationBarView()

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
        }
        .background(Color.backgroundPrimary)
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
        recipeListView(viewModel.recipes)
            .refreshable {
                await viewModel.loadRecipes()
            }
    }

    private var skeletonListView: some View {
        recipeListView(Recipe.skeletonSamples)
            .redacted(reason: .placeholder)
            .allowsHitTesting(false)
    }

    private func recipeListView(_ recipes: [Recipe]) -> some View {
        List(recipes) { recipe in
            recipeItemView(recipe)
                .listRowBackground(Color.backgroundPrimary)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary)
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
                            foregroundColor: .textPrimary,
                            backgroundColor: .accentGreen.opacity(0.50)
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
}

private extension RecipesView {
    // TODO: Proper DI
    static func makeViewModel() -> RecipesViewModel {
        let networkClient = NetworkClient()
        let service = RecipeService(networkClient: networkClient)
        let repository = RecipeRepository(recipeService: service)
        let useCase = FetchRecipesUseCase(recipeRepository: repository)

        return RecipesViewModel(fetchRecipesUseCase: useCase)
    }
}
