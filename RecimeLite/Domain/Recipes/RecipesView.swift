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
        NavigationView {
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
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    private var progressView: some View {
        ProgressView("Loading recipes...")
    }
    
    private func contentUnavailableView(errorMessage: String) -> some View {
        ContentUnavailableView(
            "Unable to Load Recipes",
            systemImage: "exclamationmark.triangle",
            description: Text(errorMessage)
        )
    }
    
    private var listView: some View {
        List(viewModel.recipes) { recipe in
            recipeItemView(recipe)
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.loadRecipes()
        }
    }
    
    // Ideally we would do RecipeResponse -> ResponseModel for UI
    func recipeItemView(_ recipe: RecipeResponse) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(recipe.title)
                    .font(.headline)
                    .primaryTextStyle()

                Spacer()

                if recipe.isVegetarian {
                    Text("Vegetarian")
                        .font(.caption)
                        .capsuleTextStyle(
                            foregroundColor: .textPrimary,
                            backgroundColor: .accentGreen.opacity(0.50)
                        )
                }
            }

            Text(recipe.description)
                .font(.subheadline)
                .secondaryTextStyle()

            Text("Servings: \(recipe.servings)")
                .font(.caption)
                .secondaryTextStyle()
        }
        .padding(.vertical, 4)
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
