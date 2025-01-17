import 'package:hungrx_app/data/Models/water_screen/delete_water_response.dart';
import 'package:hungrx_app/data/repositories/water_screen/delete_water_repository.dart';

class DeleteWaterEntryUseCase {
  final DeleteWaterRepository _repository;

  DeleteWaterEntryUseCase(this._repository);

  Future<DeleteWaterResponse> execute({
    required String userId,
    required String date,
    required String entryId,
  }) async {
    return await _repository.deleteWaterEntry(
      userId: userId,
      date: date,
      entryId: entryId,
    );
  }
}