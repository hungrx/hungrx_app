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

class ServingUnit {
  final String name;
  final String label;
  final double grams;

  ServingUnit({
    required this.name,
    required this.label,
    required this.grams,
  });
}

class CommonFoodConsumeBottomSheet extends StatefulWidget {
  final bool isHistoryScreen;
  final double calories;
  final String userId;
  final String productId;
  final String mealName;
  final String servingInfo;
  final double servingSize;

  const CommonFoodConsumeBottomSheet({
    super.key,
    required this.mealName,
    required this.calories,
    required this.servingInfo,
    required this.userId,
    required this.productId,
    required this.servingSize,
    this.isHistoryScreen = false,
  });

  @override
  State<CommonFoodConsumeBottomSheet> createState() =>
      _CommonFoodConsumeBottomSheetState();
}

class _CommonFoodConsumeBottomSheetState
    extends State<CommonFoodConsumeBottomSheet> {
  final _servingsController = TextEditingController();
  late List<ServingUnit> servingUnits;
  late String selectedServingUnit; // We'll initialize this in initState
  double numberOfServings = 1;
  double totalCalories = 0;
  String selectedMealType = 'CHOOSE';
  String? servingsError;
  double caloriesPerGram = 0;

  @override
  void initState() {
    super.initState();
    caloriesPerGram = widget.calories / widget.servingSize;
    // Initialize serving units list with the custom gram unit based on widget.servingSize
    servingUnits = [
      ServingUnit(name: 'g', label: 'Grams (g)', grams: 1),
      ServingUnit(name: 'XS', label: 'Extra Small (30g)', grams: 30),
      ServingUnit(name: 'S', label: 'Small (90g)', grams: 90),
      ServingUnit(name: 'M', label: 'Medium (180g)', grams: 180),
      ServingUnit(name: 'L', label: 'Large (250g)', grams: 250),
      ServingUnit(name: 'XL', label: 'Extra Large (500g)', grams: 500),
      ServingUnit(name: 'cup', label: 'Cup (240g)', grams: 240),
      ServingUnit(name: 'slice', label: 'Slice (22.5g)', grams: 22.5),
      ServingUnit(name: 'tsp', label: 'Teaspoon (5g)', grams: 5),
      ServingUnit(name: 'tbsp', label: 'Tablespoon (15g)', grams: 15),
      ServingUnit(name: 'oz', label: 'Ounces (28.35g)', grams: 28.35),
      ServingUnit(name: 'lb', label: 'Pounds (453.59g)', grams: 453.59),
      ServingUnit(name: 'kg', label: 'Kilograms (1000g)', grams: 1000),
    ];

    // Set the initial serving unit to grams
    selectedServingUnit = 'g';
    _servingsController.text = widget.servingSize.toString();
    totalCalories = widget.calories;
    _updateCalories(widget.servingSize.toString());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealTypeBloc>().add(FetchMealTypes());
      context.read<MealTypeBloc>().add(SelectMealType(mealId: 'breakfast_id'));
    });
  }
    void _handleServingUnitChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedServingUnit = newValue;
        // Reset quantity to 1 for all units except initial grams selection
        if (selectedServingUnit != 'g' || numberOfServings != widget.servingSize) {
          _servingsController.text = '1';
          _updateCalories('1');
        }
      });
    }
  }

  void _updateCalories(String value) {
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

      if (servings < 0.1) {
        servingsError = 'Minimum serving is 0.1';
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

      // Get the selected serving unit
      final ServingUnit unit = servingUnits.firstWhere(
        (u) => u.name == selectedServingUnit,
        orElse: () => servingUnits[0], // Default to the first unit if not found
      );

      // Calculate relative serving size compared to base serving
      // Example: if base is 82.5g and user selects 90g serving:
      // servingRatio = 90g / 82.5g = 1.09
    if (selectedServingUnit == 'g') {
        // For grams, directly calculate based on calories per gram
        totalCalories = caloriesPerGram * servings;
      } else {
        // For other units, calculate based on their gram equivalent
        double gramsInSelectedServing = unit.grams * servings;
        totalCalories = caloriesPerGram * gramsInSelectedServing;
      }

      // Calculate total calories based on serving ratio and number of servings
      // If base calories is 200 and ratio is 1.09 and servings is 2:
      // totalCalories = 200 * 1.09 * 2 = 436 calories
      // totalCalories = widget.calories * servingRatio * servings;
    });
  }

  @override
  void dispose() {
    _servingsController.dispose();
    super.dispose();
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
                            '${totalCalories.toStringAsFixed(1)} cal',
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quantity input
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quantity',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _servingsController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorText: servingsError,
                                    hintText: 'Enter quantity',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  onChanged: _updateCalories,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Serving unit dropdown
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Serving Size',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.buttonColors
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedServingUnit,
                                      isExpanded: true,
                                      dropdownColor: Colors.grey[800],
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      items:
                                          servingUnits.map((ServingUnit unit) {
                                        return DropdownMenuItem<String>(
                                          value: unit.name,
                                          child: Text(
                                            unit.label,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      }).toList(),
                                       onChanged: _handleServingUnitChange,
                                      // onChanged: (String? newValue) {
                                      //   if (newValue != null) {
                                      //     setState(() {
                                      //       selectedServingUnit = newValue;
                                      //       _updateCalories(
                                      //           _servingsController.text);
                                      //     });
                                      //   }
                                      // },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
