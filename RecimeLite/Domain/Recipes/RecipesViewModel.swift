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
        await searchRecipes(query: query, filters: RecipesFilter())
    }

    func searchRecipes(
        query: String,
        filters: RecipesFilter
    ) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedInstructionQuery = filters.instructionQuery.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedQuery.isEmpty, !filters.hasActiveFilters {
            searchedRecipes = []
            return
        }

        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            searchedRecipes = try await searchRecipesUseCase.execute(
                query: trimmedQuery.isEmpty ? nil : trimmedQuery,
                vegetarian: filters.vegetarianOnly ? true : nil,
                servings: filters.servings == 0 ? nil : filters.servings,
                includeIngredients: filters.includeIngredients.isEmpty ? nil : filters.includeIngredients,
                excludeIngredients: filters.excludeIngredients.isEmpty ? nil : filters.excludeIngredients,
                instructionQuery: trimmedInstructionQuery.isEmpty ? nil : trimmedInstructionQuery
            ).map(Recipe.init)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
