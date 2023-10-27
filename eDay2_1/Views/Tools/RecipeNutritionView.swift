import SwiftUI

struct Recipe {
    var name: String
    var ingredients: [String]
    var nutritionInfo: [Nutrition]
    var steps: [String]
    
    struct Nutrition {
        var type: NutritionType
        var value: String
        
        enum NutritionType: String {
            case protein = "hare"
            case calories = "flame"
            case carbohydrates = "leaf.arrow.triangle.circlepath"
            case fats = "drop"
            
            var description: String {
                switch self {
                case .protein: return "Protein"
                case .calories: return "Calories"
                case .carbohydrates: return "Carbohydrates"
                case .fats: return "Fats"
                }
            }
        }
    }
}

struct RecipeNutritionView: View {
    
    var recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            Image("food")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4)
                .clipped()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(recipe.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Text("Ingredients:")
                        .font(.headline)
                        .padding(.vertical, 5)
                    
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                    }
                    .padding(.leading)
                    
                    Text("Cooking Steps:")
                        .font(.headline)
                        .padding(.vertical, 5)
                    
                    ForEach(recipe.steps, id: \.self) { step in
                        Text("• \(step)")
                    }
                    .padding(.leading)
                    
                    Text("Nutrition Info:")
                        .font(.headline)
                        .padding(.vertical, 5)
                    
                    ForEach(recipe.nutritionInfo, id: \.type) { nutrition in
                        GeometryReader { geometry in
                            HStack {
                                Image(systemName: nutrition.type.rawValue)
                                    .foregroundColor(.gray)
                                    .frame(width: geometry.size.width * 0.1)
                                Text(nutrition.type.description)
                                    .frame(width: geometry.size.width * 0.6, alignment: .leading)
                                Text(nutrition.value)
                                    .frame(width: geometry.size.width * 0.25, alignment: .trailing)
                                    .padding(.trailing, geometry.size.width * 0.05)  // Adding padding to the right
                            }
                        }
                        .frame(height: 30)  // Define a height for the row
                    }
                    .padding(.leading)

                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                .padding()
            }
            .background(Color.gray.opacity(0.05))
        }
        .background(Color.gray.opacity(0.05))
    }
}


struct RecipeNutritionView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeNutritionView(recipe: Recipe(name: "Spaghetti Bolognese", ingredients: ["Spaghetti", "Tomato Sauce", "Beef Mince"], nutritionInfo: [
            Recipe.Nutrition(type: .protein, value: "25g"),
            Recipe.Nutrition(type: .calories, value: "450kcal"),
            Recipe.Nutrition(type: .carbohydrates, value: "50g"),
            Recipe.Nutrition(type: .fats, value: "15g")
        ], steps: ["Add onions, garlic, and ginger.", "Heat for 5 minutes.", "Add beef and cook until brown."]))
    }
}
