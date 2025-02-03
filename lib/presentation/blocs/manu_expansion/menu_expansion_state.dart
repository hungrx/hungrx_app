class MenuExpansionState {
  final String? expandedCategoryId;
  final String? expandedSubcategoryId;
  final String? expandedCategoryForSubcategory;

  MenuExpansionState({
    this.expandedCategoryId,
    this.expandedSubcategoryId,
    this.expandedCategoryForSubcategory,
  });

  MenuExpansionState copyWith({
    String? expandedCategoryId,
    String? expandedSubcategoryId,
    String? expandedCategoryForSubcategory,
  }) {
    return MenuExpansionState(
      expandedCategoryId: expandedCategoryId ?? this.expandedCategoryId,
      expandedSubcategoryId: expandedSubcategoryId ?? this.expandedSubcategoryId,
      expandedCategoryForSubcategory: 
          expandedCategoryForSubcategory ?? this.expandedCategoryForSubcategory,
    );
  }
}
