import Foundation
import Combine

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    var title: String {
        recipe.title
    }

    var description: String {
        recipe.description
    }

    var servingsText: String {
        recipe.servingsText
    }

    var ingredients: [RecipeIngredient] {
        recipe.ingredients
    }

    var instructions: [String] {
        recipe.instructions
    }

    var dietaryAttributes: [RecipeDietaryAttribute] {
        recipe.dietaryAttributes
    }
}
