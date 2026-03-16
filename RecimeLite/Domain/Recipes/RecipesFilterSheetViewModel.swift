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

    var canAddIncludeIngredient: Bool {
        canAddTag(
            includeIngredientsInputText,
            to: filters.includeIngredients
        )
    }

    var canAddExcludeIngredient: Bool {
        canAddTag(
            excludeIngredientsInputText,
            to: filters.excludeIngredients
        )
    }

    func resetFilters() {
        filters = RecipesFilter()
        includeIngredientsInputText = ""
        excludeIngredientsInputText = ""
        isIncludeIngredientsInputExpanded = false
        isExcludeIngredientsInputExpanded = false
    }

    func addIncludeIngredient() {
        addTag(
            from: &includeIngredientsInputText,
            to: &filters.includeIngredients
        )
    }

    func addExcludeIngredient() {
        addTag(
            from: &excludeIngredientsInputText,
            to: &filters.excludeIngredients
        )
    }

    private func addTag(
        from inputText: inout String,
        to tags: inout [String]
    ) {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard canAddTag(trimmedText, to: tags) else { return }

        tags.append(trimmedText)
        inputText = ""
    }

    private func canAddTag(
        _ inputText: String,
        to tags: [String]
    ) -> Bool {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return false }

        return !tags.contains {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
                .localizedCaseInsensitiveCompare(trimmedText) == .orderedSame
        }
    }
}
