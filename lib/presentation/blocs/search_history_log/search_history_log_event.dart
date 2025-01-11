abstract class SearchHistoryLogEvent {}

class GetSearchHistoryLogRequested extends SearchHistoryLogEvent {
  
  GetSearchHistoryLogRequested();
}

class SortSearchHistoryLogRequested extends SearchHistoryLogEvent {
  final String sortOption;
  SortSearchHistoryLogRequested({required this.sortOption});
}