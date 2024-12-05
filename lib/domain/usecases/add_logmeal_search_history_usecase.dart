import 'package:hungrx_app/data/Models/logmeal_search_history_model.dart';
import 'package:hungrx_app/data/repositories/logmeal_search_history_repository.dart';

class AddLogMealSearchHistoryUseCase {
  final LogMealSearchHistoryRepository _repository;

  AddLogMealSearchHistoryUseCase(this._repository);

  Future<LogMealSearchHistoryModel> execute({
    required String userId,
    required String productId,
  }) {
    return _repository.addToHistory(
      userId: userId,
      productId: productId,
    );
  }
}