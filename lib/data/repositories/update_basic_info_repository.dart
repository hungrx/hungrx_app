import 'package:hungrx_app/data/Models/profile_screen/update_basic_info_request.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/update_basic_info_api.dart';

class UpdateBasicInfoRepository {
  final UpdateBasicInfoApi _api;

  UpdateBasicInfoRepository(this._api);

  Future<UpdateBasicInfoResponse> updateBasicInfo(UpdateBasicInfoRequest request) {
    return _api.updateBasicInfo(request);
  }
}