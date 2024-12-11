import 'package:hungrx_app/data/Models/get_basic_info_response.dart';
import 'package:hungrx_app/data/repositories/get_basic_info_repository.dart';

class GetBasicInfoUseCase {
  final GetBasicInfoRepository _repository;

  GetBasicInfoUseCase(this._repository);

  Future<GetBasicInfoResponse> execute(String userId) {
    return _repository.getBasicInfo(userId);
  }
}
