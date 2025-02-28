import 'package:hungrx_app/data/Models/subcription_model/store_subscription.dart';
import 'package:hungrx_app/data/repositories/subscription/store_purchase_repository.dart';

class StorePurchaseUseCase {
  final StorePurchaseRepository _repository;

  StorePurchaseUseCase(this._repository);

  Future<StorePurchaseResponseModel> execute(
      StorePurchaseDetailsModel purchaseDetails) async {
    try {
      return await _repository.storePurchaseDetails(purchaseDetails);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}
