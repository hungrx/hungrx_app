import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/tdee_api_service.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/user_profile_api_client.dart';
import 'package:hungrx_app/data/repositories/profile_setting_screen/tdee_repository.dart';
import 'package:hungrx_app/data/repositories/profile_setting_screen/user_info_profile_repository.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_bloc.dart';
import 'package:hungrx_app/presentation/blocs/timezone/timezone_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/custom_button.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/header_text.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/prograss_indicator.dart';
import 'package:hungrx_app/routes/route_names.dart';

class UserInfoScreenOne extends StatefulWidget {
  const UserInfoScreenOne({super.key});

  @override
  State<UserInfoScreenOne> createState() => _UserInfoScreenOneState();
}

class _UserInfoScreenOneState extends State<UserInfoScreenOne>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = 'girl';

  Widget _buildAvatarSelection() {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Girl Avatar Option
              GestureDetector(
                onTap: () => setState(() => _selectedGender = 'girl'),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedGender == 'girl'
                          ? AppColors.buttonColors
                          : Colors.transparent,
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/dpw.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
              // Boy Avatar Option
              GestureDetector(
                onTap: () => setState(() => _selectedGender = 'boy'),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedGender == 'boy'
                          ? AppColors.buttonColors
                          : Colors.transparent,
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/dp.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Choose your avatar',
            style: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.logout();

      if (mounted) {
        // Navigate to login screen
        GoRouter.of(context).go('/phoneNumber');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error logging out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initializeUserId() async {
    final userId = await _authService.getUserId();
    _updateUserTimezone(userId ?? "");
  }

  Future<void> _updateUserTimezone(String userId) async {
    context.read<TimezoneBloc>().add(UpdateUserTimezone(userId));
  }

  Future<void> _showLogoutConfirmationDialog() async {
    if (!mounted) return;

    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: !_isLoading,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Confirm Logout',
            style: TextStyle(color: Colors.white),
          ),
          content: _isLoading
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Logging out...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : const Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(color: Colors.white),
                ),
          actions: _isLoading
              ? null
              : <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
        );
      },
    );

    if (shouldLogout == true && mounted) {
      await _handleLogout();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeUserId();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleNextButton(BuildContext context) {
    if (_nameController.text.isNotEmpty) {
      final bloc = context.read<UserProfileFormBloc>();
      bloc.add(NameChanged(_nameController.text));
      context.pushNamed(
        RouteNames.userInfoTwo,
        extra: bloc,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('What should we call you?')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tdeeApiService = TDEEApiService();
    final tdeeRepository = TDEERepository(tdeeApiService);
    final userProfileApiClient = UserProfileApiClient();
    final userProfileRepository = UserProfileRepository(userProfileApiClient);

    // Get screen size and padding
    final size = MediaQuery.of(context).size;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;

    return BlocProvider(
      create: (context) =>
          UserProfileFormBloc(userProfileRepository, tdeeRepository),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GradientContainer(
          top: size.height * 0.0,
          left: size.height * 0.01,
          right: size.height * 0.01,
          bottom: size.height * 0.01,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Progress Bar
                            Padding(
                              padding:  EdgeInsets.only(top: size.height * 0.06),
                              child: const SteppedProgressBar(
                                currentStep: 1,
                                totalSteps: 6,
                              ),
                            ),
      
                            SizedBox(height: size.height * 0.04),
      
                            FadeTransition(
                              opacity: _opacityAnimation,
                              child: const HeaderTextDataScreen(
                                data: 'Hey there! \nChoose your avatar',
                              ),
                            ),
      
                            SizedBox(height: size.height * 0.04),
      
                            _buildAvatarSelection(),
      
                            SizedBox(height: size.height * 0.03),
      
                            // Header
      
                            SizedBox(height: size.height * 0.03),
      
                            // Question Text
                            FadeTransition(
                              opacity: _opacityAnimation,
                              child: Text(
                                "Give a name to your avatar",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.width * 0.04,
                                ),
                              ),
                            ),
      
                            SizedBox(height: size.height * 0.01),
      
                            // Text Field
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: FadeTransition(
                                opacity: _opacityAnimation,
                                child: BlocBuilder<UserProfileFormBloc,
                                    UserProfileFormState>(
                                  builder: (context, state) {
                                    return CustomTextFormField(
                                      onChanged: (value) {
                                        context
                                            .read<UserProfileFormBloc>()
                                            .add(NameChanged(value));
                                      },
                                      controller: _nameController,
                                      hintText: 'Enter here',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a name';
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            // SizedBox(
                            //     height: isKeyboardVisible
                            //         ? size.height * 0.3
                            //         : size.height * 0.1),
                            // Flexible space that adjusts based on keyboard visibility
                            // Expanded(
                            //   child: !isKeyboardVisible
                            //       ? const SizedBox()
                            //       : SizedBox(height: viewInsets.bottom),
                            // ),
      
                            // Next Button
                          ],
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              isKeyboardVisible ? viewInsets.bottom + 16 : 0,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _showLogoutConfirmationDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColors,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(14),
                              ),
                              child: const Icon(Icons.logout,
                                  color: Colors.black),
                            ),
                            CustomNextButton(
                              btnName: "Next",
                              onPressed: () => _handleNextButton(context),
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
