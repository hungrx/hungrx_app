import 'package:bloc/bloc.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthService _authService;

    HomeBloc(this._authService) : super(HomeInitial()) {
    on<InitializeHomeData>((event, emit) {
      emit(HomeLoaded(event.homeData));
    });

    on<RefreshHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        final homeData = await _authService.fetchHomeData();
        if (homeData != null) {
          emit(HomeLoaded(homeData));
        } else {
          emit(HomeError('Failed to refresh home data'));
        }
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}