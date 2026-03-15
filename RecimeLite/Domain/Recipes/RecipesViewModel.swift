//
//  RecipesViewModel.swift
//  RecimeLite
//
//  Created by Codex on 3/15/26.
//

import Foundation
import Combine

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published private(set) var recipes: [RecipeResponse] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let fetchRecipesUseCase: FetchRecipesUseCaseProtocol

    init(fetchRecipesUseCase: FetchRecipesUseCaseProtocol) {
        self.fetchRecipesUseCase = fetchRecipesUseCase
    }

    func loadRecipes() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            recipes = try await fetchRecipesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
