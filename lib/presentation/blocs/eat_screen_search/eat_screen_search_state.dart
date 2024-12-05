import 'package:hungrx_app/data/Models/eat_screen_search_models.dart';

abstract class EatScreenSearchState {}

class SearchInitial extends EatScreenSearchState {}

class SearchLoading extends EatScreenSearchState {
  final String lastQuery;
  SearchLoading(this.lastQuery);
}

class SearchSuccess extends EatScreenSearchState {
  final List<SearchItemModel> results;
  final String query;
  SearchSuccess(this.results, this.query);
}

class SearchError extends EatScreenSearchState {
  final String message;
  final String query;
  SearchError(this.message, this.query);
}