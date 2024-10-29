import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/datasources/api/tdee_api_service.dart';
import 'package:hungrx_app/data/datasources/api/user_profile_api_client.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tdeeApiService = TDEEApiService();
final tdeeRepository = TDEERepository(tdeeApiService);
    final userProfileApiClient = UserProfileApiClient();
    final userProfileRepository = UserProfileRepository(userProfileApiClient);
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => UserProfileFormBloc(
              userProfileRepository,
            tdeeRepository),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: GradientContainer(
          top: size.height * 0.06,
          left: size.height * 0.01,
          right: size.height * 0.01,
          bottom: size.height * 0.01,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SteppedProgressBar(
                    currentStep: 1,
                    totalSteps: 6,
                  ),
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: const HeaderTextDataScreen(
                      data: 'Hey there! \nTell Us About Yourself',
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: const Text(
                      "What's your Name ?",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child:
                        BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
                            builder: (context, state) {
                      return CustomTextFormField(
                          onChanged: (value) {
                            context
                                .read<UserProfileFormBloc>()
                                .add(NameChanged(value));
                          },
                          controller: _nameController,
                          hintText: 'Enter Your Name');
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Spacer(),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CustomNextButton(
                        onPressed: () {
                          if (_nameController.text.isNotEmpty) {
                            final bloc = context.read<UserProfileFormBloc>();
                            bloc.add(NameChanged(_nameController.text));
                            context.pushNamed(
                              RouteNames.userInfoTwo,
                              extra: bloc,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter your age')),
                            );
                          }
                        },
                        height: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
