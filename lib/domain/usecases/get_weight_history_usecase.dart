import 'package:hungrx_app/data/Models/weight_history_model.dart';
import 'package:hungrx_app/data/repositories/weight_history_repository.dart';

class GetWeightHistoryUseCase {
  final WeightHistoryRepository _repository;

  GetWeightHistoryUseCase(this._repository);

  Future<WeightHistoryModel> execute(String userId) async {
    return await _repository.getWeightHistory(userId);
  }
}