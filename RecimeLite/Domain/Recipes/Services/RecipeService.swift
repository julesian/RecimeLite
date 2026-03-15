//
//  RecipeService.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

// Note: Mock request (.mockRequest) can be swapped in for ease of access

import Foundation

final class RecipeService: RecipeServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func fetchRecipes() async throws -> [RecipeResponse] {
        #if DEBUG
        try await networkClient.mockRequest(
            RecipeRequest.fetchRecipes,
            as: [RecipeResponse].self,
            behavior: .willDeliver(speed: .fast)
        )
        #else
        try await networkClient.request(
            RecipeRequest.fetchRecipes,
            as: [RecipeResponse].self
        )
        #endif
    }

    func searchRecipes(
        query: String?,
        vegetarian: Bool?,
        servings: Int?,
        includeIngredients: [String]?,
        excludeIngredients: [String]?,
        instructionQuery: String?
    ) async throws -> [RecipeResponse] {
    #if DEBUG
        try await networkClient.mockRequest(
            RecipeRequest.searchRecipes(
                query: query,
                vegetarian: vegetarian,
                servings: servings,
                includeIngredients: includeIngredients,
                excludeIngredients: excludeIngredients,
                instructionQuery: instructionQuery
            ),
            as: [RecipeResponse].self,
            behavior: .willDeliver(speed: .slow)
        )
    #else
        try await networkClient.request(
            RecipeRequest.searchRecipes(
                query: query,
                vegetarian: vegetarian,
                servings: servings,
                includeIngredients: includeIngredients,
                excludeIngredients: excludeIngredients,
                instructionQuery: instructionQuery
            ),
            as: [RecipeResponse].self
        )
    #endif
    }
}
