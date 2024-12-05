import 'package:hungrx_app/data/Models/eat_screen_model.dart';
import 'package:hungrx_app/data/repositories/eat_screen_repository.dart';

class GetEatScreenUseCase {
  final EatScreenRepository _repository;

  GetEatScreenUseCase(this._repository);

  Future<EatScreenModel> execute(String userId) async {
    return await _repository.getEatScreenData(userId);
  }
}