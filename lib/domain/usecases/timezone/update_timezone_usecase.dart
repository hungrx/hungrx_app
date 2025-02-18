import 'package:hungrx_app/data/Models/timezone/timezone_model.dart';
import 'package:hungrx_app/data/repositories/timezone/timezone_repository.dart';

class UpdateTimezoneUseCase {
  final TimezoneRepository _repository;

  UpdateTimezoneUseCase(this._repository);

  Future<TimezoneModel> execute(String userId) async {
    return await _repository.updateUserTimezone(userId);
  }
}