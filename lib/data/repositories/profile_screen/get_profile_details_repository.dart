import 'package:hungrx_app/data/Models/profile_screen/get_profile_details_model.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/get_profile_details_api.dart';

class GetProfileDetailsRepository {
  final GetProfileDetailsApi _api;

  GetProfileDetailsRepository(this._api);

  Future<GetProfileDetailsModel> getProfileDetails(String userId) async {
    try {
      final data = await _api.getProfileDetails(userId);
      return GetProfileDetailsModel.fromJson(data);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}