//
//  RecipeServiceProtocol.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [RecipeResponse]
    
    func searchRecipes(
        query: String?,
        vegetarian: Bool?,
        servings: Int?,
        includeIngredients: [String]?,
        excludeIngredients: [String]?,
        instructionQuery: String?
    ) async throws -> [RecipeResponse]
}
