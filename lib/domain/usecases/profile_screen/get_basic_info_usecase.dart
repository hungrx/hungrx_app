import 'package:hungrx_app/data/Models/profile_screen/get_basic_info_response.dart';
import 'package:hungrx_app/data/repositories/profile_screen/get_basic_info_repository.dart';

class GetBasicInfoUseCase {
  final GetBasicInfoRepository _repository;

  GetBasicInfoUseCase(this._repository);

  Future<GetBasicInfoResponse> execute(String userId) {
    return _repository.getBasicInfo(userId);
  }
}
