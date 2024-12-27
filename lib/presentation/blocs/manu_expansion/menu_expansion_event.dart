abstract class MenuExpansionEvent {}

class ToggleCategory extends MenuExpansionEvent {
  final String categoryId;
  ToggleCategory(this.categoryId);
}

class ToggleSubcategory extends MenuExpansionEvent {
  final String categoryId;
  final String subcategoryId;
  ToggleSubcategory(this.categoryId, this.subcategoryId);
}