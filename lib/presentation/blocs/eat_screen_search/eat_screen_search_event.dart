abstract class EatScreenSearchEvent {}

class SearchTextChanged extends EatScreenSearchEvent {
  final String query;
  SearchTextChanged(this.query);
}
