import 'package:bloc/bloc.dart';
import 'package:hungrx_app/data/repositories/get_profile_details_repository.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_event.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_state.dart';

class GetProfileDetailsBloc extends Bloc<GetProfileDetailsEvent, GetProfileDetailsState> {
  final GetProfileDetailsRepository repository;

  GetProfileDetailsBloc({required this.repository}) : super(GetProfileDetailsInitial()) {
    on<FetchProfileDetails>(_onFetchProfileDetails);
  }

  Future<void> _onFetchProfileDetails(
    FetchProfileDetails event,
    Emitter<GetProfileDetailsState> emit,
  ) async {
    emit(GetProfileDetailsLoading());
    try {
      final profileDetails = await repository.getProfileDetails(event.userId);
      emit(GetProfileDetailsSuccess(profileDetails));
    } catch (e) {
      emit(GetProfileDetailsFailure(e.toString()));
    }
  }
}
