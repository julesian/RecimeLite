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
                    .foregroundStyle(.textPrimary)
                
                // TODO: add style for primary text

                Spacer()

                if recipe.isVegetarian {
                    Text("Vegetarian")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.accentGreen.opacity(0.50))
                        .foregroundStyle(.textPrimary)
                        .clipShape(Capsule())
                    
                    // TODO: add style for capsule text
                }
            }

            Text(recipe.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // TODO: add style for secondary text

            Text("Servings: \(recipe.servings)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // TODO: add style for teritary text
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
