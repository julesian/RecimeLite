import Foundation
import Combine

@MainActor
final class RecipesSheetFilterViewModel: ObservableObject {
    @Published var filters: RecipesFilter
    @Published var includeIngredientsInputText = ""
    @Published var excludeIngredientsInputText = ""
    @Published var isIncludeIngredientsInputExpanded = false
    @Published var isExcludeIngredientsInputExpanded = false

    init(filters: RecipesFilter) {
        self.filters = filters
    }

    func resetFilters() {
        filters = RecipesFilter()
        includeIngredientsInputText = ""
        excludeIngredientsInputText = ""
        isIncludeIngredientsInputExpanded = false
        isExcludeIngredientsInputExpanded = false
    }
}
