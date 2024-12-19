import 'package:hungrx_app/data/Models/profile_screen/get_basic_info_response.dart';

abstract class GetBasicInfoState {}

class GetBasicInfoInitial extends GetBasicInfoState {}

class GetBasicInfoLoading extends GetBasicInfoState {}

class GetBasicInfoSuccess extends GetBasicInfoState {
  final UserBasicInfo userInfo;
  GetBasicInfoSuccess(this.userInfo);
}

class GetBasicInfoFailure extends GetBasicInfoState {
  final String error;
  GetBasicInfoFailure(this.error);
}