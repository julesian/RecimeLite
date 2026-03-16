import Foundation

struct RecipeIngredient: Hashable, Sendable {
    let name: String
    let quantity: Double?
    let unit: String?

    var measurementText: String? {
        let quantityText = quantity.map(formatRecipeIngredientQuantity) ?? ""
        let unitText = unit?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let measurement = [quantityText, unitText]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return measurement.isEmpty ? nil : measurement
    }
}

struct RecipeDietaryAttribute: Hashable, Sendable {
    let name: String

    var backgroundColor: ColorToken {
        switch normalizedName {
        case "vegetarian": .accentGreen
        case "vegan": .accentBlue
        case "high protein": .accentOrange
        case "gluten free": .accentYellow
        default: .accentPurple
        }
    }

    private var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

enum ColorToken {
    case accentGreen
    case accentBlue
    case accentOrange
    case accentYellow
    case accentPurple
}

struct Recipe: Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    let description: String
    let servings: Int
    let ingredients: [RecipeIngredient]
    let instructions: [String]
    let dietaryAttributes: [RecipeDietaryAttribute]
}

extension Recipe {
    init(response: RecipeResponse) {
        id = response.id
        title = response.title
        description = response.description
        servings = response.servings
        ingredients = response.ingredients.map {
            RecipeIngredient(
                name: $0.name,
                quantity: $0.quantity,
                unit: $0.unit
            )
        }
        instructions = response.instructions
        dietaryAttributes = response.dietaryAttributes.map { RecipeDietaryAttribute(name: $0) }
    }

    var servingsText: String {
        "Servings: \(servings)"
    }

    var isVegetarian: Bool {
        dietaryAttributes.contains {
            $0.name.trimmingCharacters(in: .whitespacesAndNewlines)
                .caseInsensitiveCompare("Vegetarian") == .orderedSame
        }
    }

    static let skeletonSamples: [Recipe] = [
        Recipe(
            id: -1,
            title: "Vegetarian Pasta",
            description: "Simple tomato pasta.",
            servings: 2,
            ingredients: [
                RecipeIngredient(name: "Spaghetti", quantity: 200, unit: "g"),
                RecipeIngredient(name: "Crushed Tomato", quantity: 2, unit: "cups"),
                RecipeIngredient(name: "Garlic", quantity: 3, unit: "cloves"),
                RecipeIngredient(name: "Olive Oil", quantity: 2, unit: "tbsp")
            ],
            instructions: [
                "Boil the pasta until al dente.",
                "Cook the tomato sauce with garlic.",
                "Toss together and serve warm."
            ],
            dietaryAttributes: [RecipeDietaryAttribute(name: "Vegetarian")]
        ),
        Recipe(
            id: -2,
            title: "Chicken Rice Bowl",
            description: "Chicken with rice and vegetables.",
            servings: 4,
            ingredients: [
                RecipeIngredient(name: "Chicken Breast", quantity: 2, unit: nil),
                RecipeIngredient(name: "Cooked Rice", quantity: 3, unit: "cups"),
                RecipeIngredient(name: "Broccoli", quantity: 2, unit: "cups"),
                RecipeIngredient(name: "Soy Sauce", quantity: 3, unit: "tbsp")
            ],
            instructions: [
                "Cook the rice until fluffy.",
                "Cook the chicken until golden.",
                "Serve with vegetables and sauce."
            ],
            dietaryAttributes: [RecipeDietaryAttribute(name: "High Protein")]
        ),
        Recipe(
            id: -3,
            title: "Garlic Noodle Stir-Fry",
            description: "Quick noodles with greens.",
            servings: 3,
            ingredients: [
                RecipeIngredient(name: "Noodles", quantity: 250, unit: "g"),
                RecipeIngredient(name: "Garlic", quantity: 4, unit: "cloves"),
                RecipeIngredient(name: "Mixed Greens", quantity: 2, unit: "cups"),
                RecipeIngredient(name: "Sesame Oil", quantity: 1, unit: "tbsp")
            ],
            instructions: [
                "Cook the noodles.",
                "Stir-fry garlic and greens.",
                "Combine and season before serving."
            ],
            dietaryAttributes: [
                RecipeDietaryAttribute(name: "Vegetarian"),
                RecipeDietaryAttribute(name: "Vegan")
            ]
        ),
        Recipe(
            id: -4,
            title: "Salmon Grain Bowl",
            description: "Salmon with grains and herbs.",
            servings: 2,
            ingredients: [
                RecipeIngredient(name: "Salmon Fillet", quantity: 2, unit: nil),
                RecipeIngredient(name: "Cooked Grains", quantity: 2, unit: "cups"),
                RecipeIngredient(name: "Fresh Herbs", quantity: 2, unit: "tbsp"),
                RecipeIngredient(name: "Lemon", quantity: 1, unit: nil)
            ],
            instructions: [
                "Cook the grains.",
                "Pan-sear the salmon.",
                "Finish with herbs and lemon."
            ],
            dietaryAttributes: [RecipeDietaryAttribute(name: "High Protein")]
        )
    ]
}

private func formatRecipeIngredientQuantity(_ value: Double) -> String {
    if value.rounded() == value {
        return String(Int(value))
    }

    return String(format: "%.2f", value)
        .replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
        .replacingOccurrences(of: #"\.$"#, with: "", options: .regularExpression)
}
