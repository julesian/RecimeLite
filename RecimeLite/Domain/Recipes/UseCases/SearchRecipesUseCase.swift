//
//  SearchRecipesUseCaseProtocol.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//


import Foundation

protocol SearchRecipesUseCaseProtocol {
    func execute(
        query: String?,
        vegetarian: Bool?,
        servings: Int?,
        includeIngredients: [String]?,
        excludeIngredients: [String]?,
        instructionQuery: String?
    ) async throws -> [RecipeResponse]
}

final class SearchRecipesUseCase: SearchRecipesUseCaseProtocol {
    private let recipeRepository: RecipeRepository

    init(recipeRepository: RecipeRepository) {
        self.recipeRepository = recipeRepository
    }

    func execute(
        query: String?,
        vegetarian: Bool?,
        servings: Int?,
        includeIngredients: [String]?,
        excludeIngredients: [String]?,
        instructionQuery: String?
    ) async throws -> [RecipeResponse] {
        try await recipeRepository.searchRecipes(
            query: query,
            vegetarian: vegetarian,
            servings: servings,
            includeIngredients: includeIngredients,
            excludeIngredients: excludeIngredients,
            instructionQuery: instructionQuery
        )
    }
}
