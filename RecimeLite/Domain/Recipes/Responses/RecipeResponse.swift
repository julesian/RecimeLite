//
//  Recipe.swift
//  RecimeLite
//
//  Created by Jules Ian Gilos on 3/15/26.
//

import Foundation

struct RecipeResponse: Decodable, Identifiable, Sendable {
    let id: Int
    let title: String
    let description: String
    let servings: Int
    let ingredients: [String]
    let instructions: [String]
    let isVegetarian: Bool
}
