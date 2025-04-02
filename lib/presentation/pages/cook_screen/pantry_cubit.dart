import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/Models/cook_screen/ingredient_model.dart';


// Cubit for managing state
class PantryCubit extends Cubit<List<IngredientCategory>> {
  PantryCubit() : super(_generateMockData());

  // Mock data generator
  static List<IngredientCategory> _generateMockData() {
    return [
      IngredientCategory(
        name: "Vegetables & Greens",
        totalCount: 120,
        ingredients: [
          Ingredient(name: "butter"),
          Ingredient(name: "egg"),
          Ingredient(name: "garlic powder"),
          Ingredient(name: "onion"),
          Ingredient(name: "flour"),
          Ingredient(name: "rice"),
          Ingredient(name: "white rice"),
          Ingredient(name: "cinamon"),
          Ingredient(name: "avocadio"),
          Ingredient(name: "mayonnaise"),
          Ingredient(name: "vegetable oil"),
          Ingredient(name: "potato"),
        ],
      ),
      IngredientCategory(
        name: "Mushrooms",
        totalCount: 120,
        ingredients: [
          Ingredient(name: "butter"),
          Ingredient(name: "egg"),
          Ingredient(name: "garlic powder"),
          Ingredient(name: "onion"),
          Ingredient(name: "flour"),
          Ingredient(name: "rice"),
          Ingredient(name: "white rice"),
          Ingredient(name: "cinamon"),
          Ingredient(name: "avocadio"),
          Ingredient(name: "mayonnaise"),
          Ingredient(name: "vegetable oil"),
          Ingredient(name: "potato"),
        ],
      ),
      IngredientCategory(
        name: "Fruits",
        totalCount: 120,
        ingredients: [
          Ingredient(name: "butter"),
          Ingredient(name: "egg"),
          Ingredient(name: "garlic powder"),
          Ingredient(name: "onion"),
          Ingredient(name: "flour"),
          Ingredient(name: "rice"),
        ],
      ),
          IngredientCategory(
        name: "veg",
        totalCount: 120,
        ingredients: [
          Ingredient(name: "butter"),
          Ingredient(name: "egg"),
          Ingredient(name: "garlic powder"),
          Ingredient(name: "onion"),
          Ingredient(name: "flour"),
          Ingredient(name: "rice"),
        ],
      ),
    ];
  }

  // Toggle the selection status of an ingredient
  void toggleIngredient(String categoryName, String ingredientName) {
    final updatedCategories = state.map((category) {
      if (category.name == categoryName) {
        final updatedIngredients = category.ingredients.map((ingredient) {
          if (ingredient.name == ingredientName) {
            return Ingredient(name: ingredient.name, isSelected: !ingredient.isSelected);
          }
          return ingredient;
        }).toList();
        
        return IngredientCategory(
          name: category.name,
          ingredients: updatedIngredients,
          isExpanded: category.isExpanded,
          totalCount: category.totalCount,
        );
      }
      return category;
    }).toList();
    
    emit(updatedCategories);
  }

  // Toggle the expansion state of a category
  void toggleCategoryExpansion(String categoryName) {
    final updatedCategories = state.map((category) {
      if (category.name == categoryName) {
        return IngredientCategory(
          name: category.name,
          ingredients: category.ingredients,
          isExpanded: !category.isExpanded,
          totalCount: category.totalCount,
        );
      }
      return category;
    }).toList();
    
    emit(updatedCategories);
  }

  // Clear all selected ingredients
  void clearSelectedIngredients() {
    final updatedCategories = state.map((category) {
      final updatedIngredients = category.ingredients.map((ingredient) {
        return Ingredient(name: ingredient.name, isSelected: false);
      }).toList();
      
      return IngredientCategory(
        name: category.name,
        ingredients: updatedIngredients,
        isExpanded: category.isExpanded,
        totalCount: category.totalCount,
      );
    }).toList();
    
    emit(updatedCategories);
  }

  // Get all selected ingredients
  List<Ingredient> getAllSelectedIngredients() {
    List<Ingredient> selectedIngredients = [];
    
    for (final category in state) {
      selectedIngredients.addAll(
        category.ingredients.where((ingredient) => ingredient.isSelected)
      );
    }
    
    return selectedIngredients;
  }
}