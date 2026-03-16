import Foundation
import Combine

@MainActor
final class RecipesSheetFilterViewModel: ObservableObject {
    @Published var filters: RecipesFilter

    init(filters: RecipesFilter) {
        self.filters = filters
    }

    func resetFilters() {
        filters = RecipesFilter()
    }
}
