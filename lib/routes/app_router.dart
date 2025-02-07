import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/Models/profile_setting_screen/tdee_result_model.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_bloc.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_bloc.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_state.dart';
import 'package:hungrx_app/presentation/layout/root_layout.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/forgot_password.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/otp_screen.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/phone_number.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/basic_information_screen/basic_informaion_screen.dart';
import 'package:hungrx_app/presentation/pages/daily_insight_screen/daily_insight.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/help_support_screen.dart/widgets/feedbacks_widget.dart';
import 'package:hungrx_app/presentation/pages/eat_screen/eat_screen.dart';
import 'package:hungrx_app/presentation/pages/eat_screen/widgets/search_widget.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/food_cart_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/dialy_activity_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/goal_pace_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/goal_selection_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/tdee_result_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/user_info_three.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/user_info_two.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/userr_info_one.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/dashboard_screen.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/log_meal_screen.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/food_search_screen.dart';
import 'package:hungrx_app/presentation/pages/restaurant_menu_screen/restaurent_menu_screen.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/restaurant_screen.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/widgets/restaurant_search_screen.dart';
import 'package:hungrx_app/presentation/pages/subcription_screen/subcription_screen.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/about_screen/about_screen.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/account_settings_screen/account_settings_screen.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/goal_setting_screen/edit_goal_screen.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/goal_setting_screen/goal_settings_screen.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/help_support_screen.dart/help_support.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/user_profile_screen/user_profile_screen.dart';
import 'package:hungrx_app/presentation/pages/water_intake_screeen/water_intake.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/weight_picker.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/weight_tracking.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/splash_screen.dart';
import 'package:hungrx_app/presentation/pages/onboarding_screen/onboarding_screen.dart';

class AppRouter {
  static final GetIt getIt = GetIt.instance;

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) => RootLayout(child: child),
        routes: [
          // Home/Dashboard route
          GoRoute(
            path: '/home',
            name: RouteNames.home,
            builder: (context, state) => const DashboardScreen(),
          ),
          // Eat Screen route
          GoRoute(
            path: '/eatscreen',
            name: RouteNames.eatscreen,
            builder: (context, state) => const EatScreen(),
          ),

          // Profile route
          GoRoute(
            path: '/profile',
            name: RouteNames.profile,
            builder: (context, state) => const UserProfileScreen(),
          ),

          GoRoute(
            path: '/foodcart',
            name: RouteNames.foodcart,
            builder: (context, state) {
              return const CartScreen(
                restaurant: null,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/water-intake', // URL path
        name: RouteNames.waterIntake,
        builder: (BuildContext context, GoRouterState state) {
          return const WaterIntakeScreen();
        },
      ),
      GoRoute(
        path: '/editGoalSettings',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return GoalSettingsEditScreen(
            isMaintain: extra['isMaintain'] as bool,
            goal: extra['goal'] as String,
            targetWeight: extra['targetWeight'] as String,
            isMetric: extra['isMetric'] as bool,
            currentWeight: extra['currentWeight'] as double,
            weightGainRate: extra['weightGainRate'] as double,
            activityLevel: extra['activityLevel'] as String,
            mealsPerDay: extra['mealsPerDay'] as int,
          );
        },
      ),
      GoRoute(
        path: '/weight-picker',
        name: RouteNames.weightPicker,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return WeightPickerScreen(
            currentWeight: args['currentWeight'] as double,
            isMaintain: args['isMaintain'] as bool,
          );
        },
      ),
      GoRoute(
        path: '/eatScreenSearch',
        name: RouteNames.eatScreenSearch,
        builder: (context, state) => const SearchScreen(),
      ),
      //! log screen search food

      GoRoute(
        path: '/search',
        name: RouteNames.grocerySeach,
        builder: (context, state) => const FoodSearchScreen(),
      ),

      GoRoute(
        path: '/water-intake',
        builder: (context, state) => const WaterIntakeScreen(),
      ),

      GoRoute(
        path: '/feedback',
        name: RouteNames.feedback,
        builder: (BuildContext context, GoRouterState state) {
          return const FeedbackDialog();
        },
      ),
      // GoRoute(
      //   path: '/restaurant-search',
      //   name: RouteNames.restarantSearch,
      //   builder: (context, state) => const RestaurantSearchScreen(),
      // ),
      GoRoute(
        path: '/weight-tracking',
        name: RouteNames.weightTracking,
        builder: (context, state) => WeightTrackingScreen(
          isMaintain: state.extra as bool? ?? false, // Provide a default value
        ),
      ),
      GoRoute(
        path: '/',
        name: RouteNames.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingPage();
        },
      ),
      // GoRoute(
      //   path: '/login',
      //   name: RouteNames.login,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const EmailAuthScreen();
      //   },
      // ),
      // GoRoute(
      //   path: '/signup',
      //   name: RouteNames.signup,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const EmailAuthScreen(isSignUp: true);
      //   },
      // ),
      GoRoute(
        path: '/health-profile',
        name: RouteNames.healthProfile,
        builder: (BuildContext context, GoRouterState state) {
          return const Placeholder(); // Replace with actual HealthProfileScreen
        },
      ),
      GoRoute(
        path: '/user-info-one',
        name: RouteNames.userInfoOne,
        builder: (BuildContext context, GoRouterState state) {
          return const UserInfoScreenOne(); // Replace with actual UserInfoOneScreen
        },
      ),
      GoRoute(
        path: '/user-info-two',
        name: RouteNames.userInfoTwo,
        builder: (BuildContext context, GoRouterState state) {
          return const UserInfoScreenTwo(); // Replace with actual UserInfoTwoScreen
        },
      ),
      GoRoute(
        path: '/user-info-three',
        name: RouteNames.userInfoThree,
        builder: (BuildContext context, GoRouterState state) {
          return const UserInfoScreenThree(); // Replace with actual UserInfoThreeScreen
        },
      ),
      GoRoute(
        path: '/goal-selection',
        name: RouteNames.goalSelection,
        builder: (BuildContext context, GoRouterState state) {
          final currentWeight = state.uri.queryParameters['currentWeight']!;
          return GoalSelectionScreen(currentWeight: currentWeight);
        },
      ),
      GoRoute(
        path: '/goal-pase',
        name: RouteNames.goalPace,
        builder: (BuildContext context, GoRouterState state) {
          return const GoalPaceScreen(); // Replace with actual GoalSelectionScreen
        },
      ),
      GoRoute(
        path: '/daily-activity',
        name: RouteNames.dailyactivity,
        builder: (BuildContext context, GoRouterState state) {
          return const DailyActivityScreen(); // Replace with actual GoalSelectionScreen
        },
      ),
      GoRoute(
        path: '/forgotPassword',
        name: RouteNames.forgotPassword,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordScreen(); // Replace with actual TDEEResultsScreen
        },
      ),
      GoRoute(
        path: '/phoneNumber',
        name: RouteNames.phoneNumber,
        builder: (BuildContext context, GoRouterState state) {
          return const PhoneNumberScreen();
        },
      ),
      // GoRoute(
      //   path: '/food/:id',
      //   name: RouteNames.foodDetail,
      //   builder: (BuildContext context, GoRouterState state) {
      //     final Map<String, dynamic>? params =
      //         state.extra as Map<String, dynamic>?;

      //     if (params == null) {
      //       return const Scaffold(
      //         body: Center(child: Text('Food details not found')),
      //       );
      //     }

      //     final bool isSearchScreen =
      //         params['isSearchScreen'] as bool? ?? false;
      //     final searchFood = isSearchScreen
      //         ? params['searchFood'] as GetSearchHistoryLogItem?
      //         : null;
      //     final foodItem =
      //         !isSearchScreen ? params['foodItem'] as FoodItemModel? : null;

      //     return FoodDetailScreen(
      //       isSearchScreen: isSearchScreen,
      //       searchFood: searchFood,
      //       foodItem: foodItem,
      //     );
      //   },
      // ),
      GoRoute(
        path: '/otpVerify/:phoneNumber',
        name: RouteNames.otpVerify,
        builder: (BuildContext context, GoRouterState state) {
          final phoneNumber = state.pathParameters['phoneNumber']!;
          return OtpScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: '/tdee-results',
        name: RouteNames.tdeeResults,
        builder: (BuildContext context, GoRouterState state) {
          final tdeeResult = state.extra as TDEEResultModel;
          return TDEEResultScreen(tdeeResult: tdeeResult);
        },
      ),

      GoRoute(
        path: '/accountSettings',
        name: RouteNames.accountSettings,
        builder: (BuildContext context, GoRouterState state) {
          return const AccountSettingsScreen(); // Replace with actual HomeScreen
        },
      ),
      GoRoute(
        path: '/restaurants',
        name: RouteNames.restaurants,
        builder: (BuildContext context, GoRouterState state) {
          return const RestaurantScreen(); // Replace with actual RestaurantsScreen
        },
      ),
      GoRoute(
        path: '/logMealScreen',
        name: RouteNames.logMealScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const LogMealView(); // Replace with actual RestaurantsScreen
        },
      ),
      GoRoute(
        path: '/dailyInsightScreen',
        name: RouteNames.dailyInsightScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const DailyInsightScreen(); // Replace with actual RestaurantsScreen
        },
      ),
      GoRoute(
        path: '/basicInformationScreen',
        name: RouteNames.basicInformationScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const BasicInformationScreen(); // Replace with actual RestaurantsScreen
        },
      ),
      GoRoute(
        path: '/goalSettingsScreen',
        name: RouteNames.goalSettingsScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const GoalSettingsScreen(); // Replace with actual RestaurantsScreen
        },
      ),
      GoRoute(
        path: '/subscriptionScreen',
        name: RouteNames.subscriptionScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const SubscriptionScreen(); // Replace with actual RestaurantDetailsScreen
        },
      ),
      GoRoute(
        path: '/helpSupportScreen',
        name: RouteNames.helpSupportScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const HelpSupportScreen(); // Replace with actual RestaurantDetailsScreen
        },
      ),
      GoRoute(
        path: '/policiesScreen',
        name: RouteNames.policiesScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const PoliciesScreen(); // Replace with actual RestaurantDetailsScreen
        },
      ),
      GoRoute(
        path: '/menu',
        name: RouteNames.menu,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? extras =
              state.extra as Map<String, dynamic>?;

          return RestaurantMenuScreen(
            restaurantId: extras?['restaurantId'] as String?,
            restaurant: extras?['restaurant'] as NearbyRestaurantModel?,
          );
        },
      ),
      GoRoute(
        path: '/restaurant-search',
        name: RouteNames.restaurantSearch,
        builder: (context, state) {
          return BlocBuilder<SuggestedRestaurantsBloc,
              SuggestedRestaurantsState>(
            builder: (context, suggestedState) {
              if (suggestedState is SuggestedRestaurantsLoaded) {
                return BlocProvider(
                  create: (context) =>
                      RestaurantSearchBloc(suggestedState.restaurants),
                  child: RestaurantSearchScreen(
                      restaurants: suggestedState.restaurants),
                );
              }
              // Handle loading or error state
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),

      GoRoute(
        path: '/food-item-details',
        name: RouteNames.foodItemDetails,
        builder: (BuildContext context, GoRouterState state) {
          return const Placeholder(); // Replace with actual FoodItemDetailsScreen
        },
      ),
    ],
    // Add any global redirect logic here
    redirect: (BuildContext context, GoRouterState state) {
      // Check auth state and redirect if necessary
      return null;
    },
  );
}
