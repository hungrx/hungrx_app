import 'package:hungrx_app/data/Models/profile_screen/update_basic_info_request.dart';
import 'package:hungrx_app/data/repositories/profile_screen/update_basic_info_repository.dart';

class UpdateBasicInfoUseCase {
  final UpdateBasicInfoRepository _repository;

  UpdateBasicInfoUseCase(this._repository);

  Future<UpdateBasicInfoResponse> execute(UpdateBasicInfoRequest request) {
    return _repository.updateBasicInfo(request);
  }
}
