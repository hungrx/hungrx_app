import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/data/datasources/api/auth_screen.dart/apple_auth_api.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/consume_cart_api.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/delete_dish_cart_api.dart';
import 'package:hungrx_app/data/datasources/api/cart_screen.dart/get_cart_api.dart';
import 'package:hungrx_app/data/datasources/api/daily_insight_screen/daily_insight_datasource.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/calorie_metrics_api.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/change_calorie_goal_api.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/feedback_api_service.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/add_common_food_history_api.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/common_consume_food_api.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/custom_food_entry_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/delete_account_api.dart';
import 'package:hungrx_app/data/datasources/api/daily_insight_screen/delete_consumed_food_api_service.dart';
import 'package:hungrx_app/data/datasources/api/eat_screen/eat_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/eat_screen/eat_search_screen_api_service.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/food_search_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/get_basic_info_api.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/get_search_history_log_api.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/logmeal_search_history_api.dart';
import 'package:hungrx_app/data/datasources/api/home_meals/meal_type_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/get_profile_details_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/goal_settings_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/referral_datasource.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/report_bug_api.dart';
import 'package:hungrx_app/data/datasources/api/dashboard_screen/streak_api_service.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/tdee_api_service.dart';
import 'package:hungrx_app/data/datasources/api/profile_edit_screen/update_basic_info_api.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/user_profile_api_client.dart';
import 'package:hungrx_app/data/datasources/api/progress_bar/progress_bar_api.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_menu_screen/add_to_cart.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_menu_screen/restaurant_menu_api.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/nearby_restaurant_api.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/request_restaurant_api.dart';
import 'package:hungrx_app/data/datasources/api/restaurant_screen/suggested_restaurants_api.dart';
import 'package:hungrx_app/data/datasources/api/subscription_api.dart/store_details_sub.dart';
import 'package:hungrx_app/data/datasources/api/subscription_api.dart/store_purchase_api_client.dart';
import 'package:hungrx_app/data/datasources/api/timezone/timezone_api.dart';
import 'package:hungrx_app/data/datasources/api/verify_subscription.dart/verify_subscription.dart';
import 'package:hungrx_app/data/datasources/api/water_screen/delete_water_api.dart';
import 'package:hungrx_app/data/datasources/api/water_screen/get_water_entry_api.dart';
import 'package:hungrx_app/data/datasources/api/water_screen/water_intake_api.dart';
import 'package:hungrx_app/data/datasources/api/weight_screen/weight_history_api.dart';
import 'package:hungrx_app/data/datasources/api/weight_screen/weight_update_api.dart';
import 'package:hungrx_app/data/repositories/auth_screen/apple_auth_repository.dart';
import 'package:hungrx_app/data/repositories/auth_screen/email_signin_repository.dart';
import 'package:hungrx_app/data/repositories/cart_screen/cart_repository.dart';
import 'package:hungrx_app/data/repositories/cart_screen/consume_cart_repository.dart';
import 'package:hungrx_app/data/repositories/cart_screen/delete_dish_cart_repository.dart';
import 'package:hungrx_app/data/repositories/auth_screen/connectivity_repository.dart';
import 'package:hungrx_app/data/repositories/daily_insight_screen/daily_insight_repository.dart';
import 'package:hungrx_app/data/repositories/dashboad_screen/calorie_metrics_repository.dart';
import 'package:hungrx_app/data/repositories/dashboad_screen/change_calorie_goal_repository.dart';
import 'package:hungrx_app/data/repositories/dashboad_screen/feedback_repository.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/add_common_food_history_repository.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/common_consume_food_repository.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/common_food_repository.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/custom_food_entry_repository.dart';
import 'package:hungrx_app/data/repositories/profile_screen/referral_repository.dart';
import 'package:hungrx_app/data/repositories/profile_setting_screen/goal_settings_repository.dart';
import 'package:hungrx_app/data/repositories/profile_screen/delete_account_repository.dart';
import 'package:hungrx_app/data/repositories/daily_insight_screen/delete_consumed_food_repository.dart';
import 'package:hungrx_app/data/repositories/eat_screen/eat_screen_repository.dart';
import 'package:hungrx_app/data/repositories/eat_screen/eat_search_screen_repository.dart';
import 'package:hungrx_app/data/repositories/home_meals_screen/food_search_repository.dart';
import 'package:hungrx_app/data/repositories/profile_screen/get_basic_info_repository.dart';
import 'package:hungrx_app/data/repositories/profile_screen/get_profile_details_repository.dart';
import 'package:hungrx_app/data/repositories/auth_screen/google_auth_repository.dart';
import 'package:hungrx_app/data/repositories/log_screen/logmeal_search_history_repository.dart';
import 'package:hungrx_app/data/repositories/log_screen/meal_type_repository.dart';
import 'package:hungrx_app/data/repositories/otp_auth_screen/otp_repository.dart';
import 'package:hungrx_app/data/repositories/profile_screen/report_bug_repository.dart';
import 'package:hungrx_app/data/repositories/progress_bar/progress_bar_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_menu_screen/cart_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_menu_screen/restaurant_menu_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/nearby_restaurant_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/request_restaurant_repository.dart';
import 'package:hungrx_app/data/repositories/restaurant_screen/suggested_restaurants_repository.dart';
import 'package:hungrx_app/data/repositories/log_screen/search_history_log_repository.dart';
import 'package:hungrx_app/data/repositories/dashboad_screen/streak_repository.dart';
import 'package:hungrx_app/data/repositories/profile_setting_screen/tdee_repository.dart';
import 'package:hungrx_app/data/repositories/profile_screen/update_basic_info_repository.dart';
import 'package:hungrx_app/data/repositories/profile_setting_screen/user_info_profile_repository.dart';
import 'package:hungrx_app/data/repositories/subscription/store_details_sub.dart';
import 'package:hungrx_app/data/repositories/subscription/store_purchase_repository_impl.dart';
import 'package:hungrx_app/data/repositories/subscription/subscription_repository.dart';
import 'package:hungrx_app/data/repositories/timezone/timezone_repository.dart';
import 'package:hungrx_app/data/repositories/verify_subscription/verify_subscription_repository.dart';
import 'package:hungrx_app/data/repositories/water_screen/delete_water_repository.dart';
import 'package:hungrx_app/data/repositories/water_screen/get_water_entry_repository.dart';
import 'package:hungrx_app/data/repositories/water_screen/water_intake_repository.dart';
import 'package:hungrx_app/data/repositories/weight_screen/weight_history_repository.dart';
import 'package:hungrx_app/data/repositories/weight_screen/weight_update_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/data/services/hive_service.dart';
import 'package:hungrx_app/data/services/purchase_service.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/apple_sign_in_usecase.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/login_usecase.dart';
import 'package:hungrx_app/domain/usecases/cart_screen.dart/consume_cart_usecase.dart';
import 'package:hungrx_app/domain/usecases/cart_screen.dart/delete_dish_cart_usecase.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/change_calorie_goal_usecase.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/get_calorie_metrics_usecase.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/add_common_food_history_usecase.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/add_logmeal_search_history_usecase.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/common_consume_food_usecase.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/custom_food_entry_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/delete_account_usecase.dart';
import 'package:hungrx_app/domain/usecases/daily_insight_screen/delete_consumed_food_usecase.dart';
import 'package:hungrx_app/domain/usecases/eat_screen/eat_screen_search_food_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/get_basic_info_usecase.dart';
import 'package:hungrx_app/domain/usecases/eat_screen/get_eat_screen_usecase.dart';
import 'package:hungrx_app/domain/usecases/home_meals_screen/get_meal_types_usecase.dart';
import 'package:hungrx_app/domain/usecases/eat_screen/get_search_history_log_usecase.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/get_streak_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_setting_screen/get_goal_settings_usecase.dart';
import 'package:hungrx_app/domain/usecases/restaurant_menu.dart/add_to_cart_usecase.dart';
import 'package:hungrx_app/domain/usecases/restaurant_screen/get_suggested_restaurants_usecase.dart';
import 'package:hungrx_app/domain/usecases/dashboad_screen/submit_feedback_usecase.dart';
import 'package:hungrx_app/domain/usecases/restaurant_screen/request_restaurant_usecase.dart';
import 'package:hungrx_app/domain/usecases/subscrition_screen.dart/store_details_sub.dart';
import 'package:hungrx_app/domain/usecases/subscrition_screen.dart/store_purchase_usecase.dart';
import 'package:hungrx_app/domain/usecases/subscrition_screen.dart/subscriptiion_usecase.dart';
import 'package:hungrx_app/domain/usecases/timezone/update_timezone_usecase.dart';
import 'package:hungrx_app/domain/usecases/verify_subscription/verify_subscription_usecase.dart';
import 'package:hungrx_app/domain/usecases/water_screen/delete_water_entry_usecase.dart';
import 'package:hungrx_app/domain/usecases/water_screen/get_water_entry_usecase.dart';
import 'package:hungrx_app/domain/usecases/weight_screen/get_weight_history_usecase.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/google_auth_usecase.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/otp_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/report_bug_usecase.dart';
import 'package:hungrx_app/domain/usecases/profile_screen/update_basic_info_usecase.dart';
import 'package:hungrx_app/domain/usecases/weight_screen/update_weight_usecase.dart';
import 'package:hungrx_app/firebase_options.dart';
import 'package:hungrx_app/presentation/blocs/add_common_food_history/add_common_food_history_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_meal_log_screen/add_meal_log_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_to_cart/add_to_cart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/apple_auth/apple_auth_bloc.dart';
import 'package:hungrx_app/presentation/blocs/calorie_metrics_dashboad/calorie_metrics_dashboad_bloc.dart';
import 'package:hungrx_app/presentation/blocs/change_calorie_goal/change_calorie_goal_bloc.dart';
import 'package:hungrx_app/presentation/blocs/check_subscription/check_subscription_bloc.dart';
import 'package:hungrx_app/presentation/blocs/common_food_search/common_food_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/consume_cart/consume_cart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/consume_common_food/consume_common_food_bloc.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_bloc.dart';
import 'package:hungrx_app/presentation/blocs/custom_food_entry/custom_food_entry_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_account/delete_account_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_dish/delete_dish_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_water/delete_water_bloc.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/email_login_bloc/login_bloc.dart';
import 'package:hungrx_app/presentation/blocs/feedback_bloc/feedback_bloc.dart';
import 'package:hungrx_app/presentation/blocs/foodConsumedDelete/food_consumed_delete_bloc.dart';
import 'package:hungrx_app/presentation/blocs/food_kart/food_kart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_basic_info/get_basic_info_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_cart_items/get_cart_items_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_profile_details/get_profile_details_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_water_entry/get_water_entry_bloc.dart';
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
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_bloc.dart';
import 'package:hungrx_app/presentation/blocs/referral/referral_bloc.dart';
import 'package:hungrx_app/presentation/blocs/report_bug/report_bug_bloc.dart';
import 'package:hungrx_app/presentation/blocs/request_restaurant/request_restaurant_bloc.dart';
import 'package:hungrx_app/presentation/blocs/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:hungrx_app/presentation/blocs/result_bloc/result_bloc.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_bloc.dart';
import 'package:hungrx_app/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:hungrx_app/presentation/blocs/streak_bloc/streaks_bloc.dart';
import 'package:hungrx_app/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_bloc.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_event.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_bloc.dart';
import 'package:hungrx_app/presentation/blocs/update_basic_info/update_basic_info_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/verify_referral_bloc/verify_referral_bloc.dart';
import 'package:hungrx_app/presentation/blocs/water_intake/water_intake_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_bloc.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/user_profile_screen/user_profile_screen.dart';
import 'package:hungrx_app/routes/app_router.dart';
import 'package:hungrx_app/domain/usecases/auth_screens/sign_up_usecase.dart';
import 'package:hungrx_app/data/repositories/auth_screen/email_sign_up_repository.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PurchaseService.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    // ignore: avoid_print
    print('Firebase initialization error: $e');
  }
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final upgrader = Upgrader(
      debugLogging: true,
      minAppVersion: '2.0.0', // Adjust this as needed.
      messages: UpgraderMessages(
        code: 'en',
      ),
      debugDisplayAlways: true, // Use false in production.
    );

    final commonFoodApi = CommonFoodApi();
    final commonFoodRepository = ConsumeCommonFoodRepository(commonFoodApi);
    final commonFoodUseCase = CommonFoodUseCase(commonFoodRepository);
    final progressBarApi = ProgressBarApi();
    final progressBarRepository = ProgressBarRepository(progressBarApi);
    final waterIntakeApi = GetWaterIntakeApi();
    final waterIntakeRepository = GetWaterIntakeRepository(waterIntakeApi);
    final getWaterIntakeUseCase = GetWaterIntakeUseCase(waterIntakeRepository);
    final suggestedRestaurantsApi = SuggestedRestaurantsApi();
    final storePurchaseApiClient = StorePurchaseApiClient();
    final storePurchaseRepository =
        StorePurchaseRepositoryImpl(apiClient: storePurchaseApiClient);
    final storePurchaseUseCase = StorePurchaseUseCase(storePurchaseRepository);
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
    final weightHistoryRepository = WeightHistoryRepository(weightHistoryApi);
    final getWeightHistoryUseCase =
        GetWeightHistoryUseCase(weightHistoryRepository);
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
        BlocProvider<ProgressBarBloc>(
          create: (context) =>
              ProgressBarBloc(progressBarRepository, authService),
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
        BlocProvider<CommonFoodBloc>(
          create: (context) => CommonFoodBloc(commonFoodUseCase),
        ),

        BlocProvider<AddCommonFoodHistoryBloc>(
          create: (context) => AddCommonFoodHistoryBloc(
            AddCommonFoodHistoryUseCase(
              AddCommonFoodHistoryRepository(
                AddCommonFoodHistoryApi(),
              ),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => TimezoneBloc(
            UpdateTimezoneUseCase(
              TimezoneRepository(
                TimezoneApi(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ReferralBloc(
            repository: ReferralRepository(
              dataSource: ReferralDataSource(
                client: http.Client(),
              ),
            ),
            authService: authService,
          ),
          child: const UserProfileScreen(),
        ),

        BlocProvider(
          create: (context) => AppleAuthBloc(
            appleSignInUseCase: AppleSignInUseCase(
              AppleAuthRepository(
                api: AppleAuthApi(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => SubscriptionBloc(
            SubscriptionUseCase(
              SubscriptionRepository(),
            ),
            storePurchaseUseCase,
            authService,
            StoreRevenueCatDetailsUseCase(
              RevenueCatRepositoryImpl(
                apiClient: RevenueCatApiClient(),
              ),
            ),
          ),
        ),

        BlocProvider(
          create: (context) => WeightUpdateBloc(
            UpdateWeightUseCase(
              WeightUpdateRepository(
                WeightUpdateApiService(),
              ),
            ),
            AuthService(),
          ),
        ),

        BlocProvider<RestaurantMenuBloc>(
          create: (context) => RestaurantMenuBloc(
            repository: RestaurantMenuRepository(RestaurantMenuApi()),
            authService: authService,
          ),
        ),
        BlocProvider(
          create: (context) => CheckStatusSubscriptionBloc(
              verifySubscriptionUseCase: VerifySubscriptionUseCase(
                  repository: VerifySubscriptionRepository(
                      apiClient: VerifySubscriptionApiClient()))),
        ),

        BlocProvider(
          create: (context) => NearbyRestaurantBloc(
            NearbyRestaurantRepository(
              NearbyRestaurantApi(),
            ),
          ),
        ),

        // BlocProvider(create: (context) => UserBloc()..add(LoadUserId())),
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

        BlocProvider<GetWaterIntakeBloc>(
          create: (context) =>
              GetWaterIntakeBloc(getWaterIntakeUseCase, authService),
        ),
        BlocProvider<WaterIntakeBloc>(
          create: (context) => WaterIntakeBloc(
            authService: AuthService(),
            repository: WaterIntakeRepository(
              api: WaterIntakeApi(
                client: http.Client(),
              ),
            ),
          ),
        ),

        BlocProvider<DeleteWaterBloc>(
          create: (context) => DeleteWaterBloc(
              DeleteWaterEntryUseCase(
                DeleteWaterRepository(
                  DeleteWaterApi(),
                ),
              ),
              authService),
        ),

        BlocProvider<SuggestedRestaurantsBloc>(
          create: (context) =>
              SuggestedRestaurantsBloc(getSuggestedRestaurantsUseCase)
                ..add(FetchSuggestedRestaurants()), // Initialize with data
        ),

        BlocProvider(
          create: (context) =>
              GetBasicInfoBloc(getBasicInfoUseCase, authService),
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
              authService: authService),
        ),
        BlocProvider(
          create: (context) => LogMealSearchHistoryBloc(
              addLogMealSearchHistoryUseCase, authService),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(
            FoodSearchRepository(
              FoodSearchApi(),
            ),
          ),
        ),
        // BlocProvider<WeightUpdateBloc>(
        //   create: (context) => WeightUpdateBloc(
        //     updateWeightUseCase,
        //     authService,
        //     // Add your repository/usecase here
        //   ),
        // ),
        BlocProvider<CalorieMetricsBloc>(
          create: (context) => CalorieMetricsBloc(
              GetCalorieMetricsUseCase(
                CalorieMetricsRepository(
                  CalorieMetricsApi(),
                ),
              ),
              authService),
        ),
        BlocProvider<DeleteFoodBloc>(
          create: (context) => DeleteFoodBloc(
              DeleteConsumedFoodUseCase(
                DeleteFoodRepository(
                  DeleteFoodApiService(),
                ),
              ),
              authService),
        ),

        BlocProvider<VerifyReferralBloc>(
          create: (BuildContext context) => VerifyReferralBloc(
            authService: authService,
          ),
        ),
        BlocProvider(
          create: (context) => SignUpBloc(
            signUpUseCase: SignUpUseCase(
              UserSignUpRepository(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => FeedbackBloc(
            SubmitFeedbackUseCase(
              FeedbackRepository(
                FeedbackApiService(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
            loginUseCase: LoginUseCase(
              UserSignInRepository(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ChangeCalorieGoalBloc(
              ChangeCalorieGoalUseCase(
                ChangeCalorieGoalRepository(
                  ChangeCalorieGoalApi(),
                ),
              ),
              authService),
        ),
        BlocProvider<DailyInsightBloc>(
          create: (context) => DailyInsightBloc(
              DailyInsightRepository(
                DailyInsightDataSource(),
              ),
              authService),
        ),
        BlocProvider(
          create: (context) => RequestRestaurantBloc(
              RequestRestaurantUseCase(
                RequestRestaurantRepository(
                  RequestRestaurantApi(),
                ),
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
          create: (context) =>
              WeightHistoryBloc(getWeightHistoryUseCase, authService
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
          create: (context) => CustomFoodEntryBloc(
            CustomFoodEntryUseCase(
              CustomFoodEntryRepository(
                CustomFoodEntryApi(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ConsumeCartBloc(
            ConsumeCartUseCase(
              ConsumeCartRepository(
                ConsumeCartApi(),
              ),
            ),
            authService,
          ),
        ),
        BlocProvider(
          create: (context) => CommonFoodSearchBloc(
            repository: CommonFoodRepository(),
          ),
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
        supportedLocales: const [
          Locale('en', ''),
        ],
        builder: (context, child) {
          child = UpgradeAlert(
            upgrader: upgrader,
            child: child ?? const SizedBox(),
          );

          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child,
          );
        },
      ),
    );
  }
}
