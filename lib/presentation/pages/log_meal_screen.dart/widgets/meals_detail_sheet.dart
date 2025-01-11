import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/add_meal_request.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_event.dart';
import 'package:hungrx_app/presentation/blocs/add_logscreen_search_history/add_logscreen_search_history_state.dart';
import 'package:hungrx_app/presentation/blocs/add_meal_log_screen/add_meal_log_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_meal_log_screen/add_meal_log_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/add_meal_log_screen/add_meal_log_screen_state.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_bloc.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_event.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_state.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_bloc.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_event.dart';
import 'package:hungrx_app/presentation/controller/home_data_notifier.dart';

class MealDetailsBottomSheet extends StatefulWidget {
  final bool isHistoryScreen;
  final double calories;
  final String userId;
  final String productId;
  final String mealName;
  final String servingInfo;

  const MealDetailsBottomSheet({
    super.key,
    required this.mealName,
    required this.calories,
    required this.servingInfo,
    required this.userId,
    required this.productId,
    this.isHistoryScreen = false,
  });

  @override
  State<MealDetailsBottomSheet> createState() => _MealDetailsBottomSheetState();
}

class _MealDetailsBottomSheetState extends State<MealDetailsBottomSheet> {
  final _servingsController = TextEditingController(text: '1');
  double numberOfServings = 1;
  double totalCalories = 0;
  String selectedMealType = 'CHOOSE';
  String? servingsError;

  @override
  void initState() {
    super.initState();
    totalCalories = widget.calories;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealTypeBloc>().add(FetchMealTypes());
      context.read<MealTypeBloc>().add(SelectMealType(mealId: 'breakfast_id'));
    });
  }

  @override
  void dispose() {
    _servingsController.dispose();
    super.dispose();
  }

  void _updateServings(String value) {
    setState(() {
      servingsError = null;
      if (value.isEmpty) {
        servingsError = 'Please enter number of servings';
        totalCalories = 0;
        numberOfServings = 0;
        return;
      }

      final servings = double.tryParse(value);
      if (servings == null) {
        servingsError = 'Please enter a valid number';
        totalCalories = 0;
        numberOfServings = 0;
        return;
      }

      if (servings < 1) {
        servingsError = 'Minimum serving is 1';
        totalCalories = 0;
        numberOfServings = 0;
        return;
      }

      if (servings > 1000) {
        servingsError = 'Maximum serving is 1000';
        totalCalories = 0;
        numberOfServings = 0;
        return;
      }

      numberOfServings = servings;
      totalCalories = widget.calories * servings;
    });
  }

  void _handleAddToMeal() {
    if (selectedMealType == 'CHOOSE') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a meal type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (servingsError != null || numberOfServings == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid number of servings'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = AddMealRequest(
      userId: widget.userId,
      mealType: selectedMealType.toLowerCase(),
      servingSize: numberOfServings,
      selectedMeal: widget.productId,
      dishId: widget.productId,
      totalCalories: totalCalories,
    );
    // ! for animating the calorie count
    HomeDataNotifier.decreaseCalories(totalCalories);
    context.read<AddMealBloc>().add(AddMealSubmitted(request));

    if (!widget.isHistoryScreen) {
      context.read<LogMealSearchHistoryBloc>().add(
            AddToLogMealSearchHistory(
              productId: widget.productId,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddMealBloc, AddMealState>(
          listener: (context, state) {
            if (state is AddMealSuccess) {
              context.read<SearchHistoryLogBloc>().add(
                    GetSearchHistoryLogRequested(),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.message),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pop(context);
            } else if (state is AddMealFailure) {
              // print(state.error);
              // print("heelo");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<LogMealSearchHistoryBloc, LogMealSearchHistoryState>(
          listener: (context, state) {
            if (state is LogMealSearchHistorySuccess) {
              context.read<SearchHistoryLogBloc>().add(
                    GetSearchHistoryLogRequested(),
                  );
            } else if (state is LogMealSearchHistoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: AppColors.buttonColors, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.buttonColors,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Text(
                              widget.mealName,
                              style: const TextStyle(
                                overflow: TextOverflow.clip,
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${totalCalories.toInt()} cal',
                            style: const TextStyle(
                              color: AppColors.buttonColors,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.servingInfo,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Number of servings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _servingsController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: servingsError != null
                                  ? Colors.red
                                  : AppColors.buttonColors,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: servingsError != null
                                  ? Colors.red
                                  : AppColors.buttonColors.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: servingsError != null
                                  ? Colors.red
                                  : AppColors.buttonColors,
                            ),
                          ),
                          errorText: servingsError,
                          errorStyle: const TextStyle(color: Colors.red),
                          hintText: 'Enter number of servings',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: _updateServings,
                      ),
                      const SizedBox(height: 24),
                      // !
                      BlocBuilder<MealTypeBloc, MealTypeState>(
                        builder: (context, state) {
                          if (state is MealTypeLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  color: AppColors.buttonColors,
                                ),
                              ),
                            );
                          }

                          if (state is MealTypeError) {
                            return Center(
                              child: Column(
                                children: [
                                  Text(
                                    state.message,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<MealTypeBloc>()
                                          .add(FetchMealTypes());
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state is MealTypeLoaded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Meal Type',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: state.mealTypes.map((mealType) {
                                      bool isSelected =
                                          state.selectedMealId == mealType.id;
                                      return InkWell(
                                        onTap: () {
                                          context.read<MealTypeBloc>().add(
                                                SelectMealType(
                                                    mealId: mealType.id),
                                              );
                                          setState(() {
                                            selectedMealType =
                                                mealType.meal.toUpperCase();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.buttonColors
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.buttonColors
                                                  : Colors.grey,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isSelected
                                                    ? Icons.check_circle
                                                    : Icons.circle_outlined,
                                                size: 18,
                                                color: isSelected
                                                    ? Colors.black
                                                    : Colors.grey,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                mealType.meal,
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? Colors.black
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: BlocBuilder<AddMealBloc, AddMealState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is AddMealLoading
                                  ? null
                                  : _handleAddToMeal,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColors,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 2,
                              ),
                              child: state is AddMealLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black),
                                      ),
                                    )
                                  : Text(
                                      selectedMealType == 'CHOOSE'
                                          ? "CHOOSE MEAL"
                                          : 'ADD TO $selectedMealType',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
