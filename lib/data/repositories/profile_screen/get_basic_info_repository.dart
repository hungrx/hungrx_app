import 'package:hungrx_app/data/Models/profile_screen/get_basic_info_response.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/get_basic_info_api.dart';

class GetBasicInfoRepository {
  final GetBasicInfoApi _api;

  GetBasicInfoRepository(this._api);

  Future<GetBasicInfoResponse> getBasicInfo(String userId) async {
    try {
      final response = await _api.getBasicInfo(userId);
      return GetBasicInfoResponse.fromJson(response);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}