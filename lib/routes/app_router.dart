import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/Models/tdee_result_model.dart';
import 'package:hungrx_app/data/datasources/api/weight_update_api.dart';
import 'package:hungrx_app/data/repositories/weight_update_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/domain/usecases/update_weight_usecase.dart';
import 'package:hungrx_app/presentation/blocs/email_login_bloc/login_bloc.dart';
import 'package:hungrx_app/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_bloc.dart';
import 'package:hungrx_app/presentation/layout/root_layout.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/forgot_password.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/otp_screen.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/phone_number.dart';
import 'package:hungrx_app/presentation/pages/eat_screen/eat_screen.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/food_cart_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/dialy_activity_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/goal_pace_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/goal_selection_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/tdee_result_screen.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/user_info_three.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/user_info_two.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/userr_info_one.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/dashboard_screen.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/account_settings_screen/account_settings_screen.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/user_profile_screen/user_profile_screen.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/weight_picker.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/weight_tracking.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/email_auth_screen.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/splash_screen.dart';
import 'package:hungrx_app/presentation/pages/onboarding_screen/onboarding_screen.dart';
import 'package:hungrx_app/domain/usecases/sign_up_usecase.dart';
import 'package:hungrx_app/domain/usecases/login_usecase.dart';
import 'package:hungrx_app/data/repositories/email_sign_up_repository.dart';
import 'package:hungrx_app/data/repositories/email_signin_repository.dart';

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
          // Cart route
          GoRoute(
            path: '/foodcart',
            name: RouteNames.foodcart,
            builder: (context, state) => const CartScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/weight-picker',
        name: RouteNames.weightPicker,
        builder: (context, state) => BlocProvider(
          create: (context) => WeightUpdateBloc(
            UpdateWeightUseCase(
              WeightUpdateRepository(
                WeightUpdateApiService(),
              ),
            ),
            AuthService(),
          ),
          child: const WeightPickerScreen(),
        ),
      ),
      GoRoute(
        path: '/weight-tracking',
        name: RouteNames.weightTracking,
        builder: (context, state) => const WeightTrackingScreen(),
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
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SignUpBloc(
                  signUpUseCase: SignUpUseCase(
                    UserSignUpRepository(),
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
            ],
            child: const EmailAuthScreen(),
          );
        },
      ),
      GoRoute(
        path: '/signup',
        name: RouteNames.signup,
        builder: (BuildContext context, GoRouterState state) {
          return const EmailAuthScreen(isSignUp: true);
        },
      ),
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
          return const GoalSelectionScreen(); // Replace with actual GoalSelectionScreen
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
          return const Placeholder(); // Replace with actual RestaurantsScreen
        },
      ),
      GoRoute(
        path: '/restaurant-details',
        name: RouteNames.restaurantDetails,
        builder: (BuildContext context, GoRouterState state) {
          return const Placeholder(); // Replace with actual RestaurantDetailsScreen
        },
      ),
      GoRoute(
        path: '/menu',
        name: RouteNames.menu,
        builder: (BuildContext context, GoRouterState state) {
          return const Placeholder(); // Replace with actual MenuScreen
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
