// lib/core/di/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/tdee_api_service.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/user_profile_api_client.dart';
import 'package:hungrx_app/data/repositories/profile_setting_screen/tdee_repository.dart';
import 'package:hungrx_app/data/repositories/profile_setting_screen/user_info_profile_repository.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // API Clients
  getIt.registerLazySingleton(() => UserProfileApiClient());
  getIt.registerLazySingleton(() => TDEEApiService());

  // Repositories
  // getIt.registerLazySingleton(
  //   () => UserProfileRepository(getIt<UserProfileApiClient>()),
  // );
  getIt.registerLazySingleton(
    () => TDEERepository(getIt<TDEEApiService>()),
  );

  // BLoCs
  getIt.registerFactory(
    () => UserProfileFormBloc(
      getIt<UserProfileRepository>(),
      getIt<TDEERepository>(),
    ),
  );
}

// Optional: You might want to add cleanup method
void cleanupDependencies() {
  getIt.unregister<UserProfileApiClient>();
  getIt.unregister<TDEEApiService>();
  getIt.unregister<UserProfileRepository>();
  getIt.unregister<TDEERepository>();
  getIt.unregister<UserProfileFormBloc>();
}
