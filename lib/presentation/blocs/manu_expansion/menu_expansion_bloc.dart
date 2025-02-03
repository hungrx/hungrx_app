import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_event.dart';
import 'package:hungrx_app/presentation/blocs/manu_expansion/menu_expansion_state.dart';

class MenuExpansionBloc extends Bloc<MenuExpansionEvent, MenuExpansionState> {
  MenuExpansionBloc() : super(MenuExpansionState()) {
    on<ToggleCategory>((event, emit) {
      if (state.expandedCategoryId == event.categoryId) {
        // If clicking the same category that's already expanded, collapse it
        emit(MenuExpansionState()); // Reset state
      } else {
        // If clicking a different category, expand it while preserving subcategory state
        emit(MenuExpansionState(
          expandedCategoryId: event.categoryId,
          // Reset subcategory when changing main category
          expandedSubcategoryId: null,
          expandedCategoryForSubcategory: null,
        ));
      }
    });

    on<ToggleSubcategory>((event, emit) {
      if (state.expandedSubcategoryId == event.subcategoryId &&
          state.expandedCategoryForSubcategory == event.categoryId) {
        // If clicking the same subcategory that's already expanded, only collapse the subcategory
        emit(state.copyWith(
          expandedSubcategoryId: null,
          expandedCategoryForSubcategory: null,
          // Preserve main category expansion state
          expandedCategoryId: state.expandedCategoryId,
        ));
      } else {
        // If clicking a different subcategory, expand it while preserving main category state
        emit(state.copyWith(
          expandedCategoryId: state.expandedCategoryId, // Preserve main category state
          expandedSubcategoryId: event.subcategoryId,
          expandedCategoryForSubcategory: event.categoryId,
        ));
      }
    });
  }
}