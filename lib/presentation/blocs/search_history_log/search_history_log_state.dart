import 'package:hungrx_app/data/Models/get_search_history_log_response.dart';

abstract class SearchHistoryLogState {}

class SearchHistoryLogInitial extends SearchHistoryLogState {}

class SearchHistoryLogLoading extends SearchHistoryLogState {}

class SearchHistoryLogSuccess extends SearchHistoryLogState {
  final List<GetSearchHistoryLogItem> items;
  final String currentSortOption;

  SearchHistoryLogSuccess({
    required this.items,
    required this.currentSortOption,
  });

  SearchHistoryLogSuccess copyWith({
    List<GetSearchHistoryLogItem>? items,
    String? currentSortOption,
  }) {
    return SearchHistoryLogSuccess(
      items: items ?? this.items,
      currentSortOption: currentSortOption ?? this.currentSortOption,
    );
  }
}

class SearchHistoryLogFailure extends SearchHistoryLogState {
  final String error;
  SearchHistoryLogFailure({required this.error});
}
