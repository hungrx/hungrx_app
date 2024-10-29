import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/datasources/api/streak_api_service.dart';
import 'package:hungrx_app/data/datasources/api/tdee_api_service.dart';
import 'package:hungrx_app/data/datasources/api/user_profile_api_client.dart';
import 'package:hungrx_app/data/repositories/connectivity_repository.dart';
import 'package:hungrx_app/data/repositories/facebook_auth_repository.dart';
import 'package:hungrx_app/data/repositories/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/otp_repository.dart';
import 'package:hungrx_app/data/repositories/streak_repository.dart';
import 'package:hungrx_app/data/repositories/tdee_repository.dart';
import 'package:hungrx_app/data/repositories/user_info_profile_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/facebook_auth_usecase.dart';
import 'package:hungrx_app/domain/usecases/get_streak_usecase.dart';
import 'package:hungrx_app/domain/usecases/google_auth_usecase.dart';
import 'package:hungrx_app/domain/usecases/otp_usecase.dart';
import 'package:hungrx_app/firebase_options.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_bloc.dart';
import 'package:hungrx_app/presentation/blocs/facebook_auth/facebook_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/result_bloc/result_bloc.dart';
import 'package:hungrx_app/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/routes/app_router.dart';
import 'package:hungrx_app/domain/usecases/sign_up_usecase.dart';
import 'package:hungrx_app/data/repositories/email_sign_up_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // print('Flutter Error: ${details.exception}');
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final connectivityRepository = ConnectivityRepository();
    final authService = AuthService();
    final streakApiService = StreakApiService();
    final streakRepository = StreakRepository(streakApiService);
    final getStreakUseCase = GetStreakUseCase(streakRepository);
    final tdeeApiService = TDEEApiService();
    final userProfileApiClient = UserProfileApiClient();
    final tdeeRepository = TDEERepository(tdeeApiService);
    final userProfileRepository = UserProfileRepository(userProfileApiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(
            signUpUseCase: SignUpUseCase(
              UserSignUpRepository(),
            ),
          ),
        ),
        BlocProvider<StreakBloc>(
          create: (context) => StreakBloc(getStreakUseCase),
        ),

         BlocProvider<ConnectivityBloc>(
          create: (context) => ConnectivityBloc(
            connectivityRepository: connectivityRepository,
          ),
        ),

        BlocProvider<OtpAuthBloc>(
          create: (context) => OtpAuthBloc(
            otpUseCase: OtpUseCase(
              OtpRepository(),
            ),
          ),
        ),
        BlocProvider<UserProfileFormBloc>(
          create: (context) => UserProfileFormBloc(
            userProfileRepository,
            tdeeRepository,
          ),
        ),
        // In main.dart, add this to your BlocProvider list
        BlocProvider<GoogleAuthBloc>(
          create: (context) => GoogleAuthBloc(
            googleAuthUseCase: GoogleAuthUseCase(
              GoogleAuthRepository(),
            ),
          ),
        ),

        BlocProvider<FacebookAuthBloc>(
          create: (context) => FacebookAuthBloc(
            facebookAuthUseCase: FacebookAuthUseCase(
              FacebookAuthRepository(),
            ),
          ),
        ),
        BlocProvider<CountryCodeBloc>(
          create: (context) => CountryCodeBloc(),
        ),
        BlocProvider<TDEEBloc>(
          create: (context) => TDEEBloc(tdeeRepository),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(authService),
        ),

        // Add other global BLoCs here
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'hungrX',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
