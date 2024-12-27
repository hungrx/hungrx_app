import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_event.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_state.dart';

class MenuExpansionBloc extends Bloc<MenuExpansionEvent, MenuExpansionState> {
  MenuExpansionBloc() : super(MenuExpansionState()) {
    on<ToggleCategory>((event, emit) {
      // If clicking the same category that's already expanded, collapse it
      if (state.expandedCategoryId == event.categoryId) {
        emit(MenuExpansionState()); // Reset state
      } else {
        // If clicking a different category, expand it and collapse others
        emit(MenuExpansionState(
          expandedCategoryId: event.categoryId,
          expandedSubcategoryId: null, // Reset subcategory when changing category
          expandedCategoryForSubcategory: null,
        ));
      }
    });

    on<ToggleSubcategory>((event, emit) {
      // If clicking the same subcategory that's already expanded, collapse it
      if (state.expandedSubcategoryId == event.subcategoryId) {
        emit(state.copyWith(
          expandedSubcategoryId: null,
          expandedCategoryForSubcategory: null,
        ));
      } else {
        // If clicking a different subcategory, expand it and collapse others
        emit(state.copyWith(
          expandedCategoryId: event.categoryId,
          expandedSubcategoryId: event.subcategoryId,
          expandedCategoryForSubcategory: event.categoryId,
        ));
      }
    });
  }
}