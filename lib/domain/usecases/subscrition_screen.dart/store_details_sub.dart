import 'package:hungrx_app/data/Models/subcription_model/store_details_sub.dart';
import 'package:hungrx_app/data/repositories/subscription/store_details_sub.dart';

class StoreRevenueCatDetailsUseCase {
  final RevenueCatRepository _repository;

  StoreRevenueCatDetailsUseCase(this._repository);

  Future<RevenueCatResponseModel> execute(
      RevenueCatDetailsModel details) async {
    try {
      return await _repository.storeRevenueCatDetails(details);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}
