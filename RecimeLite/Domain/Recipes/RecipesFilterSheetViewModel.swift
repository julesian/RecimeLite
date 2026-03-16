import Foundation
import Combine

@MainActor
final class RecipesSheetFilterViewModel: ObservableObject {
    @Published var filters: RecipesFilter
    @Published var instructionQueryInputText: String
    @Published var includeIngredientsInputText = ""
    @Published var excludeIngredientsInputText = ""
    @Published var isIncludeIngredientsInputExpanded = false
    @Published var isExcludeIngredientsInputExpanded = false

    init(filters: RecipesFilter) {
        self.filters = filters
        instructionQueryInputText = filters.instructionQuery
    }

    var canAddIncludeIngredient: Bool {
        canAddTag(
            includeIngredientsInputText,
            to: filters.includeIngredients,
            excluding: filters.excludeIngredients
        )
    }

    var canAddExcludeIngredient: Bool {
        canAddTag(
            excludeIngredientsInputText,
            to: filters.excludeIngredients,
            excluding: filters.includeIngredients
        )
    }

    func resetFilters() {
        filters = RecipesFilter()
        instructionQueryInputText = ""
        includeIngredientsInputText = ""
        excludeIngredientsInputText = ""
        isIncludeIngredientsInputExpanded = false
        isExcludeIngredientsInputExpanded = false
    }

    func clearInstructionQuery() {
        instructionQueryInputText = ""
    }

    var appliedFilters: RecipesFilter {
        var appliedFilters = filters
        appliedFilters.instructionQuery = instructionQueryInputText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return appliedFilters
    }

    func addIncludeIngredient() {
        addTag(
            from: &includeIngredientsInputText,
            to: &filters.includeIngredients,
            excluding: filters.excludeIngredients
        )
    }

    func addExcludeIngredient() {
        addTag(
            from: &excludeIngredientsInputText,
            to: &filters.excludeIngredients,
            excluding: filters.includeIngredients
        )
    }

    private func addTag(
        from inputText: inout String,
        to tags: inout [String],
        excluding otherTags: [String]
    ) {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard canAddTag(trimmedText, to: tags, excluding: otherTags) else { return }

        tags.append(trimmedText)
        inputText = ""
    }

    private func canAddTag(
        _ inputText: String,
        to tags: [String],
        excluding otherTags: [String]
    ) -> Bool {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return false }

        let allExistingTags = tags + otherTags

        return !allExistingTags.contains {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
                .localizedCaseInsensitiveCompare(trimmedText) == .orderedSame
        }
    }
}
