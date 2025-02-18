import 'package:hungrx_app/data/Models/profile_screen/update_basic_info_request.dart';

abstract class UpdateBasicInfoEvent {}

class UpdateBasicInfoSubmitted extends UpdateBasicInfoEvent {
  final UpdateBasicInfoRequest request;

  UpdateBasicInfoSubmitted(this.request);
}