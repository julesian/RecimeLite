import Foundation
import Combine

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var searchedRecipes: [Recipe] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let fetchRecipesUseCase: FetchRecipesUseCaseProtocol
    private let searchRecipesUseCase: SearchRecipesUseCaseProtocol

    init(
        fetchRecipesUseCase: FetchRecipesUseCaseProtocol,
        searchRecipesUseCase: SearchRecipesUseCaseProtocol
    ) {
        self.fetchRecipesUseCase = fetchRecipesUseCase
        self.searchRecipesUseCase = searchRecipesUseCase
    }

    func loadRecipes() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            recipes = try await fetchRecipesUseCase.execute().map(Recipe.init)
            searchedRecipes = []
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func searchRecipes(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedQuery.isEmpty {
            searchedRecipes = []
            return
        }

        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            searchedRecipes = try await searchRecipesUseCase.execute(
                query: trimmedQuery,
                vegetarian: nil,
                servings: nil,
                includeIngredients: nil,
                excludeIngredients: nil,
                instructionQuery: nil
            ).map(Recipe.init)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
