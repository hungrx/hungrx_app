import 'package:hungrx_app/data/Models/subcription_model/store_subscription.dart';

abstract class StorePurchaseRepository {
  Future<StorePurchaseResponseModel> storePurchaseDetails(
    StorePurchaseDetailsModel purchaseDetails
  );
}