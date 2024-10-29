import 'package:hungrx_app/data/Models/weight_response_model.dart';
import 'package:hungrx_app/data/repositories/weight_update_repository.dart';

class UpdateWeightUseCase {
  final WeightUpdateRepository _repository;

  UpdateWeightUseCase(this._repository);

  Future<WeightUpdateResponse> execute(String userId, double newWeight) async {
    if (newWeight <= 0) {
      throw Exception('Weight must be greater than 0');
    }
    return await _repository.updateWeight(userId, newWeight);
  }
}