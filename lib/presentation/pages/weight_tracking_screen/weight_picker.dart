import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/services/auth_service.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_update/weight_update_state.dart';

class WeightPickerScreen extends StatefulWidget {
  const WeightPickerScreen({super.key});

  @override
  WeightPickerScreenState createState() => WeightPickerScreenState();
}

class WeightPickerScreenState extends State<WeightPickerScreen> {
  final AuthService _authService = AuthService();
  String selectedValue = ''; // Default weight
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Add listener to focus node to handle keyboard dismiss
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _validateAndUpdateWeight();
      }
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _validateAndUpdateWeight() {
    if (_weightController.text.isNotEmpty) {
      double? weight = double.tryParse(_weightController.text);
      if (weight != null && weight >= 15 && weight <= 200) {
        setState(() {
          selectedValue = weight.toString();
        });
      } else {
        // Reset to previous valid value
        _weightController.text = selectedValue;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a weight between 15 and 200 kg'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<WeightUpdateBloc, WeightUpdateState>(
        listener: (context, state) {
          if (state is WeightUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is WeightUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 350, bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: AnimatedWeightPicker(
                          // initialValue: double.tryParse(selectedValue) ?? 60,
                          showSelectedValue: false,
                          dialColor: Colors.white,
                          dialHeight: 70,
                          division: 0.1,
                          majorIntervalHeight: 24,
                          majorIntervalColor: Colors.red,
                          minorIntervalHeight: 14,
                          selectedValueColor: AppColors.buttonColors,
                          min: 15,
                          max: 300,
                          onChange: (newValue) {
                            setState(() {
                              selectedValue = newValue;
                              _weightController.text = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        selectedValue,
                        style: const TextStyle(
                          fontSize: 74,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Added TextField for manual weight input
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _weightController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Enter weight in kg',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.buttonColors,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            suffixText: 'kg',
                            suffixStyle: const TextStyle(color: Colors.white),
                          ),
                          onSubmitted: (value) {
                            _validateAndUpdateWeight();
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              double? weight = double.tryParse(value);
                              if (weight != null &&
                                  weight >= 15 &&
                                  weight <= 300) {
                                setState(() {
                                  selectedValue = weight.toString();
                                });
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // const Spacer(),
                      BlocBuilder<WeightUpdateBloc, WeightUpdateState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is WeightUpdateLoading
                                ? null
                                : () async {
                                    if (selectedValue.isNotEmpty) {
                                      context.read<WeightUpdateBloc>().add(
                                            UpdateWeightRequested(
                                              double.parse(selectedValue),
                                            ),
                                          );
                                    }
                                    final homeData =
                                        await _authService.fetchHomeData();
                                        print(homeData);
                                    if (homeData != null) {
                                      // Initialize HomeBloc with fetched data
                                      context
                                          .read<HomeBloc>()
                                          .add(InitializeHomeData(homeData));
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColors,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: state is WeightUpdateLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
