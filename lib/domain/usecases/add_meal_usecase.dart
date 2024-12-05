import 'package:hungrx_app/data/Models/add_meal_request.dart';
import 'package:hungrx_app/data/repositories/add_meal_repository.dart';

class AddMealUseCase {
  final AddMealRepository _repository;

  AddMealUseCase({AddMealRepository? repository})
      : _repository = repository ?? AddMealRepository();

  Future<AddMealResponse> execute(AddMealRequest request) async {
    try {
      return await _repository.addMealToUser(request);
    } catch (e) {
      // print(e);
      throw Exception('UseCase error: $e');
    }
  }
}