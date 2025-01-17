import 'package:hungrx_app/data/Models/water_screen/delete_water_response.dart';
import 'package:hungrx_app/data/datasources/api/water_screen/delete_water_api.dart';

class DeleteWaterRepository {
  final DeleteWaterApi _api;

  DeleteWaterRepository(this._api);

  Future<DeleteWaterResponse> deleteWaterEntry({
    required String userId,
    required String date,
    required String entryId,
  }) async {
    try {
      return await _api.deleteWaterEntry(
        userId: userId,
        date: date,
        entryId: entryId,
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}