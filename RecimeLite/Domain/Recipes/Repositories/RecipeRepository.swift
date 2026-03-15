//
//  RecipeRepository.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import Foundation

final class RecipeRepository: RecipeRepositoryProtocol {
    private let recipeService: RecipeServiceProtocol

    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
    }

    func fetchRecipes() async throws -> [RecipeResponse] {
        try await recipeService.fetchRecipes()
    }

    func searchRecipes(
        query: String?,
        vegetarian: Bool?,
        servings: Int?,
        includeIngredients: [String]?,
        excludeIngredients: [String]?,
        instructionQuery: String?
    ) async throws -> [RecipeResponse] {
        try await recipeService.searchRecipes(
            query: query,
            vegetarian: vegetarian,
            servings: servings,
            includeIngredients: includeIngredients,
            excludeIngredients: excludeIngredients,
            instructionQuery: instructionQuery
        )
    }
}
