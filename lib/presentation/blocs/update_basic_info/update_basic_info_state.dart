import 'package:hungrx_app/data/Models/profile_screen/update_basic_info_request.dart';

abstract class UpdateBasicInfoState {}

class UpdateBasicInfoInitial extends UpdateBasicInfoState {}

class UpdateBasicInfoLoading extends UpdateBasicInfoState {}

class UpdateBasicInfoSuccess extends UpdateBasicInfoState {
  final UpdateBasicInfoResponse response;

  UpdateBasicInfoSuccess(this.response);
}

class UpdateBasicInfoFailure extends UpdateBasicInfoState {
  final String error;

  UpdateBasicInfoFailure(this.error);
}