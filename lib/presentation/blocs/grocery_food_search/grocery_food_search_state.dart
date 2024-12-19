import 'package:hungrx_app/data/Models/home_meals_screen/food_item_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<FoodItemModel> foods;
  SearchSuccess(this.foods);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}