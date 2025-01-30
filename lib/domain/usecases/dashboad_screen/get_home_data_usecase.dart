import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';
import 'package:hungrx_app/data/repositories/dashboad_screen/home_screen_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<HomeData> execute(String userId) async {
    try {
      return await repository.getHomeData(userId);
    } catch (e) {
      print(e);
      throw Exception('UseCase error: $e');
    }
  }
}