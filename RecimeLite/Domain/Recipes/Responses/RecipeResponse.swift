//
//  Recipe.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import Foundation

struct IngredientResponse: Decodable, Hashable, Sendable {
    let name: String
    let quantity: Double?
    let unit: String?
}

struct RecipeResponse: Decodable, Identifiable, Sendable {
    let id: Int
    let title: String
    let description: String
    let servings: Int
    let ingredients: [IngredientResponse]
    let instructions: [String]
    let dietaryAttributes: [String]
}
