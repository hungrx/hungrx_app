import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/utils/size_utils.dart';
import 'package:hungrx_app/data/datasources/api/eat_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/eat_search_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/food_search_api.dart';
import 'package:hungrx_app/data/datasources/api/get_search_history_log_api.dart';
import 'package:hungrx_app/data/datasources/api/logmeal_search_history_api.dart';
import 'package:hungrx_app/data/datasources/api/meal_type_api.dart';
import 'package:hungrx_app/data/datasources/api/streak_api_service.dart';
import 'package:hungrx_app/data/datasources/api/tdee_api_service.dart';
import 'package:hungrx_app/data/datasources/api/user_profile_api_client.dart';
import 'package:hungrx_app/data/datasources/api/weight_history_api.dart';
import 'package:hungrx_app/data/datasources/api/weight_update_api.dart';
import 'package:hungrx_app/data/repositories/connectivity_repository.dart';
import 'package:hungrx_app/data/repositories/eat_screen_repository.dart';
import 'package:hungrx_app/data/repositories/eat_search_screen_repository.dart';
import 'package:hungrx_app/data/repositories/facebook_auth_repository.dart';
import 'package:hungrx_app/data/repositories/food_search_repository.dart';
import 'package:hungrx_app/data/repositories/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/logmeal_search_history_repository.dart';
import 'package:hungrx_app/data/repositories/meal_type_repository.dart';
import 'package:hungrx_app/data/repositories/otp_repository.dart';
import 'package:hungrx_app/data/repositories/search_history_log_repository.dart';
import 'package:hungrx_app/data/repositories/streak_repository.dart';
import 'package:hungrx_app/data/repositories/tdee_repository.dart';
import 'package:hungrx_app/data/repositories/user_info_profile_repository.dart';
import 'package:hungrx_app/data/repositories/weight_history_repository.dart';
import 'package:hungrx_app/data/repositories/weight_update_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/add_logmeal_search_history_usecase.dart';
import 'package:hungrx_app/domain/usecases/eat_screen_search_food_usecase.dart';
import 'package:hungrx_app/domain/usecases/facebook_auth_usecase.dart';
import 'package:hungrx_app/domain/usecases/get_eat_screen_usecase.dart';
import 'package:hungrx_app/domain/usecases/get_meal_types_usecase.dart';
import 'package:hungrx_app/domain/usecases/get_search_history_log_usecase.dart';
import 'package:hungrx_app/domain/usecases/get_streak_usecase.dart';
import 'package:hungrx_app/domain/usecases/get_weight_history_usecase.dart';
import 'package:hungrx_app/domain/usecases/google_auth_usecase.dart';
import 'package:hungrx_app/domain/usecases/otp_usecase.dart';
import 'package:hungrx_app/domain/usecases/update_weight_usecase.dart';
import 'package:hungrx_app/firebase_options.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_meal_log_screen/add_meal_log_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_bloc.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/facebook_auth/facebook_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_bloc.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_event.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/result_bloc/result_bloc.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_bloc.dart';
import 'package:hungrx_app/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_bloc.dart';
import 'package:hungrx_app/routes/app_router.dart';
import 'package:hungrx_app/domain/usecases/sign_up_usecase.dart';
import 'package:hungrx_app/data/repositories/email_sign_up_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
    final weightHistoryApi = WeightHistoryApi();
    final weightUpdateApi = WeightUpdateApiService();
    final weightHistoryRepository = WeightHistoryRepository(weightHistoryApi);
    final weightUpdateRepository = WeightUpdateRepository(weightUpdateApi);
    final getWeightHistoryUseCase =
        GetWeightHistoryUseCase(weightHistoryRepository);
    final updateWeightUseCase = UpdateWeightUseCase(weightUpdateRepository);

    final httpClient = http.Client();
    final mealTypeApi = MealTypeApi(client: httpClient);
    final mealTypeRepository = MealTypeRepository(api: mealTypeApi);
    final getMealTypesUseCase =
        GetMealTypesUseCase(repository: mealTypeRepository);
    final connectivityRepository = ConnectivityRepository();
    final authService = AuthService();
    final streakApiService = StreakApiService();
    final streakRepository = StreakRepository(streakApiService);
    final getStreakUseCase = GetStreakUseCase(streakRepository);
    final tdeeApiService = TDEEApiService();
    final userProfileApiClient = UserProfileApiClient();
    final tdeeRepository = TDEERepository(tdeeApiService);
    final userProfileRepository = UserProfileRepository(userProfileApiClient);
    final eatScreenApiService = EatScreenApiService();
    final eatScreenRepository = EatScreenRepository(eatScreenApiService);
    final getEatScreenUseCase = GetEatScreenUseCase(eatScreenRepository);
    final logMealSearchHistoryApi = LogMealSearchHistoryApi();
    final logMealSearchHistoryRepository =
        LogMealSearchHistoryRepository(logMealSearchHistoryApi);
    final addLogMealSearchHistoryUseCase =
        AddLogMealSearchHistoryUseCase(logMealSearchHistoryRepository);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc()..add(LoadUserId())),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(
            signUpUseCase: SignUpUseCase(
              UserSignUpRepository(),
            ),
          ),
        ),
        BlocProvider(create: (_) => AddMealBloc()),
        BlocProvider<SearchHistoryLogBloc>(
          create: (context) => SearchHistoryLogBloc(
            useCase: GetSearchHistoryLogUseCase(
              repository: SearchHistoryLogRepository(
                api: GetSearchHistoryLogApi(
                  client: http.Client(),
                ),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) =>
              LogMealSearchHistoryBloc(addLogMealSearchHistoryUseCase),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(
            FoodSearchRepository(
              FoodSearchApi(),
            ),
          ),
        ),
        BlocProvider<WeightUpdateBloc>(
          create: (context) => WeightUpdateBloc(
            updateWeightUseCase,
            authService,
            // Add your repository/usecase here
          ),
        ),
        BlocProvider<WeightHistoryBloc>(
          create: (context) => WeightHistoryBloc(getWeightHistoryUseCase
              // Add your repository/usecase here
              ),
        ),
        BlocProvider<MealTypeBloc>(
          create: (context) => MealTypeBloc(
            getMealTypesUseCase: getMealTypesUseCase,
          )..add(FetchMealTypes()),
        ),
        BlocProvider<EatScreenBloc>(
          create: (context) => EatScreenBloc(getEatScreenUseCase),
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
        BlocProvider<EatScreenSearchBloc>(
          create: (context) => EatScreenSearchBloc(
            searchUseCase: EatScreenSearchFoodUsecase(
              EatSearchScreenRepository(
                EatSearchScreenApiService(),
              ),
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
        builder: (context, child) {
          SizeUtils.init(context);
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
    );
  }
}
