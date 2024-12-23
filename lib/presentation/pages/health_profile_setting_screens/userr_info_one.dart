import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/tdee_api_service.dart';
import 'package:hungrx_app/data/datasources/api/profile_setting_screens/user_profile_api_client.dart';
import 'package:hungrx_app/data/repositories/tdee_repository.dart';
import 'package:hungrx_app/data/repositories/user_info_profile_repository.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
        const SnackBar(content: Text('Please enter your name')),
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
      create: (context) => UserProfileFormBloc(userProfileRepository, tdeeRepository),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GradientContainer(
            top: size.height * 0.06,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress Bar
                      const SteppedProgressBar(
                        currentStep: 1,
                        totalSteps: 6,
                      ),
                      
                      SizedBox(height: size.height * 0.04),
                      
                      // Header
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: const HeaderTextDataScreen(
                          data: 'Hey there! \nTell Us About Yourself',
                        ),
                      ),
                      
                      SizedBox(height: size.height * 0.03),
                      
                      // Question Text
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: Text(
                          "What's your Name ?",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: size.height * 0.01),
                      
                      // Text Field
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
                          builder: (context, state) {
                            return CustomTextFormField(
                              onChanged: (value) {
                                context.read<UserProfileFormBloc>().add(NameChanged(value));
                              },
                              controller: _nameController,
                              hintText: 'Enter Your Name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      ),
                      
                      // Flexible space that adjusts based on keyboard visibility
                      Expanded(
                        child: !isKeyboardVisible
                            ? const SizedBox()
                            : SizedBox(height: viewInsets.bottom),
                      ),
                      
                      // Next Button
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: isKeyboardVisible ? viewInsets.bottom + 16 : 16,
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: CustomNextButton(
                              onPressed: () => _handleNextButton(context),
                              height: size.height * 0.06,
                            ),
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
      ),
    );
  }
}