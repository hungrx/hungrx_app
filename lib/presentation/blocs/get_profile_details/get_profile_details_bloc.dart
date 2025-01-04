import 'package:bloc/bloc.dart';
import 'package:hungrx_app/data/repositories/profile_screen/get_profile_details_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_event.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_state.dart';

class GetProfileDetailsBloc extends Bloc<GetProfileDetailsEvent, GetProfileDetailsState> {
  final GetProfileDetailsRepository repository;
  final AuthService _authService;

  GetProfileDetailsBloc({
    required this.repository,
    required AuthService authService,
  }) : _authService = authService,
       super(GetProfileDetailsInitial()) {
    on<FetchProfileDetails>(_onFetchProfileDetails);
  }

  Future<void> _onFetchProfileDetails(
    FetchProfileDetails event,
    Emitter<GetProfileDetailsState> emit,
  ) async {
    emit(GetProfileDetailsLoading());
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        emit(GetProfileDetailsFailure('User not logged in'));
        return;
      }

      final profileDetails = await repository.getProfileDetails(userId);
      emit(GetProfileDetailsSuccess(profileDetails));
    } catch (e) {
      emit(GetProfileDetailsFailure(e.toString()));
    }
  }
}