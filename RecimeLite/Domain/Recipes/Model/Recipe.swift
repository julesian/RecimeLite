import Foundation

struct Recipe: Identifiable, Sendable {
    let id: Int
    let title: String
    let description: String
    let servingsText: String
    let isVegetarian: Bool
}

extension Recipe {
    init(response: RecipeResponse) {
        id = response.id
        title = response.title
        description = response.description
        servingsText = "Servings: \(response.servings)"
        isVegetarian = response.isVegetarian
    }

    static let skeletonSamples: [Recipe] = [
        Recipe(
            id: -1,
            title: "Vegetarian Pasta",
            description: "Simple tomato pasta.",
            servingsText: "Servings: 2",
            isVegetarian: true
        ),
        Recipe(
            id: -2,
            title: "Chicken Rice Bowl",
            description: "Chicken with rice and vegetables.",
            servingsText: "Servings: 4",
            isVegetarian: false
        ),
        Recipe(
            id: -3,
            title: "Garlic Noodle Stir-Fry",
            description: "Quick noodles with greens.",
            servingsText: "Servings: 3",
            isVegetarian: true
        ),
        Recipe(
            id: -4,
            title: "Salmon Grain Bowl",
            description: "Salmon with grains and herbs.",
            servingsText: "Servings: 2",
            isVegetarian: false
        )
    ]
}
