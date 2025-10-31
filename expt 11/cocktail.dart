// This file defines the data model for a cocktail.

class Cocktail {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String instructions;
  final List<String> ingredients;

  Cocktail({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.instructions,
    required this.ingredients,
  });

  // A factory constructor to create a Cocktail from JSON.
  // The API returns ingredients and measures in separate fields (strIngredient1, strMeasure1, etc.)
  // This factory constructor cleverly parses them into a single, clean list.
  factory Cocktail.fromJson(Map<String, dynamic> json) {
    List<String> ingredientsList = [];
    for (int i = 1; i <= 15; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      // If both ingredient and measure exist, add them to the list.
      if (ingredient != null && ingredient.isNotEmpty) {
        // Trim to avoid extra whitespace
        final measureText = (measure != null && measure.isNotEmpty) ? '${measure.trim()} ' : '';
        ingredientsList.add('$measureText${ingredient.trim()}');
      }
    }

    return Cocktail(
      id: json['idDrink'],
      name: json['strDrink'],
      thumbnailUrl: json['strDrinkThumb'],
      instructions: json['strInstructions'] ?? 'No instructions available.',
      ingredients: ingredientsList,
    );
  }
}