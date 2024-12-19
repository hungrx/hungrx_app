import 'package:hungrx_app/data/Models/dashboad_screen/streak_data_model.dart';
import 'package:hungrx_app/data/repositories/streak_repository.dart';

class GetStreakUseCase {
  final StreakRepository _repository;

  GetStreakUseCase(this._repository);

  Future<StreakDataModel> execute(String userId) async {
    try {
      return await _repository.getUserStreak(userId);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}