//
//  FetchRecipesUseCaseProtocol.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import Foundation

protocol FetchRecipesUseCaseProtocol {
    func execute() async throws -> [RecipeResponse]
}

final class FetchRecipesUseCase: FetchRecipesUseCaseProtocol {
    private let recipeRepository: RecipeRepositoryProtocol

    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
    }

    func execute() async throws -> [RecipeResponse] {
        try await recipeRepository.fetchRecipes()
    }
}
