import 'package:hungrx_app/data/Models/profile_screen/get_profile_details_model.dart';

abstract class GetProfileDetailsState {}

class GetProfileDetailsInitial extends GetProfileDetailsState {}

class GetProfileDetailsLoading extends GetProfileDetailsState {}

class GetProfileDetailsSuccess extends GetProfileDetailsState {
  final GetProfileDetailsModel profileDetails;
  GetProfileDetailsSuccess(this.profileDetails);
}

class GetProfileDetailsFailure extends GetProfileDetailsState {
  final String error;
  GetProfileDetailsFailure(this.error);
}