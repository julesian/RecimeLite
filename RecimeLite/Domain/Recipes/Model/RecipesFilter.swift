import Foundation

struct RecipesFilter: Equatable {
    var servings = 0
    var vegetarianOnly = false
    var includeIngredients: [String] = []
    var excludeIngredients: [String] = []
    var instructionQuery = ""

    var hasActiveFilters: Bool {
        vegetarianOnly
            || !includeIngredients.isEmpty
            || !excludeIngredients.isEmpty
            || !instructionQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || servings != 0
    }
}
