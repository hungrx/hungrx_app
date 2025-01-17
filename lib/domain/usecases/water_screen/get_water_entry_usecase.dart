import 'package:hungrx_app/data/Models/water_screen/get_water_entry_model.dart';
import 'package:hungrx_app/data/repositories/water_screen/get_water_entry_repository.dart';

class GetWaterIntakeUseCase {
  final GetWaterIntakeRepository _repository;

  GetWaterIntakeUseCase(this._repository);

  Future<WaterIntakeData> execute(String userId, String date) async {
    try {
      return await _repository.getWaterIntakeData(userId, date);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}
