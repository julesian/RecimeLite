//
//  RecipeRequest.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import Foundation

enum RecipeRequest {
    case fetchRecipes
    case searchRecipes(
        query: String?,
        vegetarian: Bool?,
        servings: Int?,
        includeIngredients: [String]?,
        excludeIngredients: [String]?,
        instructionQuery: String?
    )
}

extension RecipeRequest: Requestable {
    // Note: Format for listing down endpoints configs, easy to read
    var config: RequestConfigurationProtocol {
        switch self {
        case .fetchRecipes:
            return RequestConfiguration(
                path: "/recipes",
                method: .get
            )

        case let .searchRecipes(
            query,
            vegetarian,
            servings,
            includeIngredients,
            excludeIngredients,
            instructionQuery
        ):

            var params: [String: Any] = [:]
            
            params.add("query", query)
            params.add("vegetarian", vegetarian)
            params.add("servings", servings)
            params.add("includeIngredients", includeIngredients)
            params.add("excludeIngredients", excludeIngredients)
            params.add("instructionQuery", instructionQuery)

            return RequestConfiguration(
                path: "/recipes/search",
                method: .get,
                queryParameters: params
            )
        }
    }

    #if DEBUG
    var mockJsonFileName: String? {
        switch self {
        case .fetchRecipes: "recipes"
        case .searchRecipes: "recipe_search_results"
        }
    }
    #endif
}
