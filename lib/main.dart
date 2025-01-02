import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/utils/size_utils.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/delete_dish_cart_api.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/get_cart_api.dart';
import 'package:hungrx_app/data/datasources/api/daily_insight_screen/daily_insight_datasource.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/delete_account_api.dart';
import 'package:hungrx_app/data/datasources/api/daily_insight_screen/delete_consumed_food_api_service.dart';
import 'package:hungrx_app/data/datasources/api/eat_screen/eat_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/eat_screen/eat_search_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/food_search_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/get_basic_info_api.dart';
import 'package:hungrx_app/data/datasources/api/eat_screen/get_search_history_log_api.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/logmeal_search_history_api.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/meal_type_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/get_profile_details_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/goal_settings_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/report_bug_api.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/streak_api_service.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/tdee_api_service.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/update_basic_info_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/user_profile_api_client.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_menu_screen/add_to_cart.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_menu_screen/restaurant_menu_api.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/nearby_restaurant_api.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/search_restaurant_api.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/suggested_restaurants_api.dart';
import 'package:hungrx_app/data/datasources/api/weight_screen/weight_history_api.dart';
import 'package:hungrx_app/data/datasources/api/weight_screen/weight_update_api.dart';
import 'package:hungrx_app/data/repositories/cart_screen/cart_repository.dart';
import 'package:hungrx_app/data/repositories/cart_screen/delete_dish_cart_repository.dart';
import 'package:hungrx_app/data/repositories/connectivity_repository.dart';
import 'package:hungrx_app/data/repositories/daily_insight_screen/daily_insight_repository.dart';
import 'package:hungrx_app/data/repositories/goal_settings_repository.dart';
import 'package:hungrx_app/data/repositories/profile_screen/delete_account_repository.dart';
import 'package:hungrx_app/data/repositories/daily_insight_screen/delete_consumed_food_repository.dart';
import 'package:hungrx_app/data/repositories/eat_screen/eat_screen_repository.dart';
import 'package:hungrx_app/data/repositories/eat_screen/eat_search_screen_repository.dart';
import 'package:hungrx_app/data/repositories/auth_screen/facebook_auth_repository.dart';
import 'package:hungrx_app/data/repositories/food_search_repository.dart';
import 'package:hungrx_app/data/repositories/profile_screen/get_basic_info_repository.dart';
import 'package:hungrx_app/data/repositories/get_profile_details_repository.dart';
import 'package:hungrx_app/data/repositories/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/logmeal_search_history_repository.dart';
import 'package:hungrx_app/data/repositories/meal_type_repository.dart';
import 'package:hungrx_app/data/repositories/otp_repository.dart';
import 'package:hungrx_app/data/repositories/report_bug_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_menu_screen/cart_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_menu_screen/restaurant_menu_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/nearby_restaurant_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/search_restaurant_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/suggested_restaurants_repository.dart';
import 'package:hungrx_app/data/repositories/search_history_log_repository.dart';
import 'package:hungrx_app/data/repositories/streak_repository.dart';
import 'package:hungrx_app/data/repositories/tdee_repository.dart';
import 'package:hungrx_app/data/repositories/update_basic_info_repository.dart';
import 'package:hungrx_app/data/repositories/user_info_profile_repository.dart';
import 'package:hungrx_app/data/repositories/weight_history_repository.dart';
import 'package:hungrx_app/data/repositories/weight_update_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/cart_screen.dart/delete_dish_cart_usecase.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/add_logmeal_search_history_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/delete_account_usecase.dart';
import 'package:hungrx_app/domain/usecases/daily_insight_screen/delete_consumed_food_usecase.dart';
import 'package:hungrx_app/domain/usecases/eat_screen/eat_screen_search_food_usecase.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/facebook_auth_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/get_basic_info_usecase.dart';
import 'package:hungrx_app/domain/usecases/eat_screen/get_eat_screen_usecase.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/get_meal_types_usecase.dart';
import 'package:hungrx_app/domain/usecases/eat_screen/get_search_history_log_usecase.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/get_streak_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_setting_screen/get_goal_settings_usecase.dart';
import 'package:hungrx_app/domain/usecases/restaurant_menu.dart/add_to_cart_usecase.dart';
import 'package:hungrx_app/domain/usecases/restaurant_screen/get_suggested_restaurants_usecase.dart';
import 'package:hungrx_app/domain/usecases/restaurant_screen/search_restaurants_usecase.dart';
import 'package:hungrx_app/domain/usecases/weight_screen/get_weight_history_usecase.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/google_auth_usecase.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/otp_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/report_bug_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/update_basic_info_usecase.dart';
import 'package:hungrx_app/domain/usecases/weight_screen/update_weight_usecase.dart';
import 'package:hungrx_app/firebase_options.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_meal_log_screen/add_meal_log_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_account/delete_account_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_bloc.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/facebook_auth/facebook_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/foodConsumedDelete/food_consumed_delete_bloc.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_bloc.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_bloc.dart';
import 'package:hungrx_app/presentation/blocs/goal_settings/goal_settings_event.dart';
import 'package:hungrx_app/presentation/blocs/google_auth/google_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/grocery_food_search/grocery_food_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_bloc.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_event.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_bloc.dart';
import 'package:hungrx_app/presentation/blocs/otp_verify_bloc/auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/report_bug/report_bug_bloc.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:hungrx_app/presentation/blocs/result_bloc/result_bloc.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_bloc.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_bloc.dart';
import 'package:hungrx_app/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_bloc.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_bloc.dart';
import 'package:hungrx_app/routes/app_router.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/sign_up_usecase.dart';
import 'package:hungrx_app/data/repositories/auth_screen/email_sign_up_repository.dart';

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
    final suggestedRestaurantsApi = SuggestedRestaurantsApi();
    final suggestedRestaurantsRepository =
        SuggestedRestaurantsRepository(suggestedRestaurantsApi);
    final getSuggestedRestaurantsUseCase =
        GetSuggestedRestaurantsUseCase(suggestedRestaurantsRepository);
    final reportBugApi = ReportBugApi();
    final reportBugRepository = ReportBugRepository(reportBugApi);
    final reportBugUseCase = ReportBugUseCase(reportBugRepository);
    final deleteAccountApi = DeleteAccountApi();
    final deleteAccountRepository =
        DeleteAccountRepository(api: deleteAccountApi);
    final deleteAccountUseCase =
        DeleteAccountUseCase(repository: deleteAccountRepository);
    final updateBasicInfoApi = UpdateBasicInfoApi();
    final updateBasicInfoRepository =
        UpdateBasicInfoRepository(updateBasicInfoApi);
    final updateBasicInfoUseCase =
        UpdateBasicInfoUseCase(updateBasicInfoRepository);
    final getBasicInfoApi = GetBasicInfoApi();
    final getBasicInfoRepository = GetBasicInfoRepository(getBasicInfoApi);
    final getBasicInfoUseCase = GetBasicInfoUseCase(getBasicInfoRepository);
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
        BlocProvider<GetProfileDetailsBloc>(
          create: (context) => GetProfileDetailsBloc(
            repository: GetProfileDetailsRepository(
              GetProfileDetailsApi(),
            ),
            authService: authService,
          ),
        ),

        // !  cart bloc in food menu
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider<DeleteAccountBloc>(
          create: (context) => DeleteAccountBloc(
            authService: authService,
            deleteAccountUseCase: deleteAccountUseCase,
          ),
        ),

        BlocProvider<RestaurantMenuBloc>(
          create: (context) => RestaurantMenuBloc(
            repository: RestaurantMenuRepository(RestaurantMenuApi()),
            authService: authService,
          ),
        ),
        BlocProvider<RestaurantSearchBloc>(
          create: (context) => RestaurantSearchBloc(
            searchUseCase: SearchRestaurantsUseCase(
              repository: SearchRestaurantRepository(
                api: SearchRestaurantApi(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => NearbyRestaurantBloc(
            NearbyRestaurantRepository(
              NearbyRestaurantApi(),
            ),
          ),
        ),

        BlocProvider(create: (context) => UserBloc()..add(LoadUserId())),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(
            signUpUseCase: SignUpUseCase(
              UserSignUpRepository(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ReportBugBloc(
            reportBugUseCase,
            authService,
          ),
        ),

        BlocProvider<SuggestedRestaurantsBloc>(
          create: (context) =>
              SuggestedRestaurantsBloc(getSuggestedRestaurantsUseCase),
        ),

        BlocProvider(
          create: (context) => GetBasicInfoBloc(getBasicInfoUseCase),
        ),
        BlocProvider(create: (_) => AddMealBloc()),
        BlocProvider(
          create: (context) => UpdateBasicInfoBloc(updateBasicInfoUseCase),
        ),
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
        BlocProvider<DeleteFoodBloc>(
          create: (context) => DeleteFoodBloc(
            DeleteConsumedFoodUseCase(
              DeleteFoodRepository(
                DeleteFoodApiService(),
              ),
            ),
          ),
        ),
        BlocProvider<DailyInsightBloc>(
          create: (context) => DailyInsightBloc(
              DailyInsightRepository(
                DailyInsightDataSource(),
              ),
              authService),
        ),

        BlocProvider(
          create: (context) => GoalSettingsBloc(
            GetGoalSettingsUseCase(
              GoalSettingsRepository(
                GoalSettingsApi(),
              ),
            ),
            authService,
          )..add(FetchGoalSettings()),
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
          create: (context) => EatScreenBloc(getEatScreenUseCase, authService),
        ),
        BlocProvider<StreakBloc>(
          create: (context) => StreakBloc(getStreakUseCase, authService),
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
        BlocProvider<GetCartBloc>(
          create: (context) => GetCartBloc(
            GetCartRepository(
              GetCartApi(),
            ),
            authService,
          ),
        ),

        BlocProvider<AddToCartBloc>(
          create: (context) => AddToCartBloc(
              AddToCartUseCase(
                AddToCartRepository(
                  AddToCartApi(),
                ),
              ),
              authService),
        ),
        BlocProvider(
          create: (context) => DeleteDishCartBloc(
            DeleteDishCartUseCase(
              DeleteDishCartRepository(
                DeleteDishCartApi(),
              ),
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
