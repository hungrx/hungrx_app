import 'package:hungrx_app/data/Models/water_screen/get_water_entry_model.dart';
import 'package:hungrx_app/data/datasources/api/water_screen/get_water_entry_api.dart';

class GetWaterIntakeRepository {
  final GetWaterIntakeApi _api;

  GetWaterIntakeRepository(this._api);

  Future<WaterIntakeData> getWaterIntakeData(String userId, String date) async {
    try {
      return await _api.getWaterIntakeData(userId, date);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}