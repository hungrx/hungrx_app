abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class PerformSearch extends SearchEvent {
  final String query;
  PerformSearch(this.query);
}

class ClearSearch extends SearchEvent {
  ClearSearch();
}