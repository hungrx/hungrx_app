import 'package:get_it/get_it.dart';
import 'package:hungrx_app/data/datasources/api/user_profile_api_client.dart';
import 'package:hungrx_app/data/repositories/user_info_profile_repository.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // API Client
  getIt.registerLazySingleton(() => UserProfileApiClient());

  // Repository
  getIt.registerLazySingleton(() => UserProfileRepository(getIt<UserProfileApiClient>()));

  // BLoC
  getIt.registerFactory(() => UserProfileFormBloc(getIt<UserProfileRepository>()));
}