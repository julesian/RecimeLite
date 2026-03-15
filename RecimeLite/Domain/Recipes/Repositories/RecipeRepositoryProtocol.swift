//
//  RecipeRepository.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

protocol RecipeRepositoryProtocol {
    func fetchRecipes() async throws -> [RecipeResponse]
    
    func searchRecipes(
        query: String?,
        vegetarian: Bool?, // Can be an enum list, or object as there are also many types of vegetarian, but for now we just use bool
        servings: Int?, // I think better if in Range, but for now we use single number
        includeIngredients: [String]?,
        excludeIngredients: [String]?,
        instructionQuery: String?
    ) async throws -> [RecipeResponse]
}
