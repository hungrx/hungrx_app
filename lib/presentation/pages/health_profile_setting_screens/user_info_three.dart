import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_bloc.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_event.dart';
import 'package:hungrx_app/presentation/blocs/userprofileform/user_profile_form_state.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/navigation_buttons.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/prograss_indicator.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/health_profile_setting_screens/widgets/toggle_button.dart';
import 'package:hungrx_app/routes/route_names.dart';

class UserInfoScreenThree extends StatefulWidget {
  const UserInfoScreenThree({super.key});

  @override
  UserInfoScreenThreeState createState() => UserInfoScreenThreeState();
}

class UserInfoScreenThreeState extends State<UserInfoScreenThree> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<UserProfileFormBloc, UserProfileFormState>(
        builder: (context, state) {
          return GradientContainer(
            top: size.height * 0.06,
            left: size.height * 0.01,
            right: size.height * 0.01,
            bottom: size.height * 0.01,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SteppedProgressBar(
                              currentStep: 3,
                              totalSteps: 6,
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              'Help Us Calculate Your\nTDEE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             const SizedBox(height: 20),
                            const Text(
                              "How many times do you typically\neat in a day?",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Slider(
                              value: state.mealsPerDay ?? 1,
                              min: 1,
                              max: 4,
                              divisions: 3,
                              activeColor: AppColors.buttonColors,
                              inactiveColor: Colors.grey[800],
                              label: state.mealsPerDay.toString(),
                              onChanged: (value) {
                                context
                                    .read<UserProfileFormBloc>()
                                    .add(MealsPerDayChanged(value));
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [1, 2, 3, 4]
                                    .map((e) => Text(
                                          e.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ))
                                    .toList(),
                              ),
                            ),


                            const SizedBox(height: 50),
                             
                            const Text(
                              "Select Measurement System",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            UnitToggle(
                              isMetric: state.isMetric,
                              onToggle: (value) {
                                context
                                    .read<UserProfileFormBloc>()
                                    .add(UnitChanged(value));
                              },
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "What's your Height?",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            if (state.isMetric)
                              CustomTextFormField(
                                controller: heightController,
                                hintText: 'Enter Your Height (cm)',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  context
                                      .read<UserProfileFormBloc>()
                                      .add(HeightChanged(value));
                                },
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: heightController,
                                      hintText: 'Feet',
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        context
                                            .read<UserProfileFormBloc>()
                                            .add(HeightFeetChanged(value));
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: inchesController,
                                      hintText: 'Inches',
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        context
                                            .read<UserProfileFormBloc>()
                                            .add(HeightInchesChanged(value));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),
                            const Text(
                              "What's your Weight?",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              controller: weightController,
                              hintText: state.isMetric
                                  ? 'Enter Your Weight (kg)'
                                  : 'Enter Your Weight (lbs)',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                context
                                    .read<UserProfileFormBloc>()
                                    .add(WeightChanged(value));
                              },
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: NavigationButtons(
                      onNextPressed: () {
                        if (heightController.text.isNotEmpty &&
                            weightController.text.isNotEmpty) {
                          final bloc = context.read<UserProfileFormBloc>();
                          if (state.isMetric) {
                            bloc.add(HeightChanged(heightController.text));
                          } else {
                            bloc.add(HeightFeetChanged(heightController.text));
                            bloc.add(
                                HeightInchesChanged(inchesController.text));
                          }
                          bloc.add(WeightChanged(weightController.text));
                       context.pushNamed(
                              RouteNames.goalSelection,
                              extra: bloc,
                            );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter your Height & Weight')),
                          );
                        }

                  
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}