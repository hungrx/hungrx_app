import 'package:hungrx_app/data/Models/water_screen/add_water_response.dart';
import 'package:hungrx_app/data/datasources/api/water_screen/water_intake_api.dart';

class WaterIntakeRepository {
  final WaterIntakeApi api;

  WaterIntakeRepository({required this.api});

  Future<AddWaterResponse> addWaterIntake({
    required String userId,
    required String amount,
  }) async {
    try {
      return await api.addWaterIntake(
        userId: userId,
        amount: amount,
      );
    } catch (e) {
      throw Exception('Repository Error: $e');
      
    }
  }
}
