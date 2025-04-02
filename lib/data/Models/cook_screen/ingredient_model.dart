  // Domain Model for ingredient
class Ingredient {
  final String name;
  bool isSelected;

  Ingredient({required this.name, this.isSelected = false});
}

// Domain Model for category
class IngredientCategory {
  final String name;
  final List<Ingredient> ingredients;
  bool isExpanded;
  final int totalCount;

  IngredientCategory({
    required this.name,
    required this.ingredients,
    this.isExpanded = false,
    required this.totalCount,
  });

  // Get the count of selected ingredients in this category
  int get selectedCount => ingredients.where((ingredient) => ingredient.isSelected).length;
}