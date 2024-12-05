abstract class SearchHistoryLogEvent {}

class GetSearchHistoryLogRequested extends SearchHistoryLogEvent {
  
  final String userId;
  GetSearchHistoryLogRequested({required this.userId});
}

class SortSearchHistoryLogRequested extends SearchHistoryLogEvent {
  final String sortOption;
  SortSearchHistoryLogRequested({required this.sortOption});
}