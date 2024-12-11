import 'package:hungrx_app/data/Models/update_basic_info_request.dart';
import 'package:hungrx_app/data/datasources/api/update_basic_info_api.dart';

class UpdateBasicInfoRepository {
  final UpdateBasicInfoApi _api;

  UpdateBasicInfoRepository(this._api);

  Future<UpdateBasicInfoResponse> updateBasicInfo(UpdateBasicInfoRequest request) {
    return _api.updateBasicInfo(request);
  }
}