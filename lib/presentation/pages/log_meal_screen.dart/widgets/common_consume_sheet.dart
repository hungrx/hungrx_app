import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/common_food/common_food_request.dart';
import 'package:hungrx_app/presentation/blocs/add_common_food_history/add_common_food_history_bloc.dart';
import 'package:hungrx_app/presentation/blocs/add_common_food_history/add_common_food_history_event.dart';
import 'package:hungrx_app/presentation/blocs/add_common_food_history/add_common_food_history_state.dart';
import 'package:hungrx_app/presentation/blocs/consume_common_food/consume_common_food_bloc.dart';
import 'package:hungrx_app/presentation/blocs/consume_common_food/consume_common_food_event.dart';
import 'package:hungrx_app/presentation/blocs/consume_common_food/consume_common_food_state.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_bloc.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_event.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_state.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_bloc.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_event.dart';
import 'package:hungrx_app/presentation/blocs/progress_bar/progress_bar_state.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_bloc.dart';
import 'package:hungrx_app/presentation/blocs/search_history_log/search_history_log_event.dart';

class ServingUnit {
  final String name;
  final String label;
  final double grams;
  final bool isDefault;

  ServingUnit({
    required this.name,
    required this.label,
    required this.grams,
    this.isDefault = false,
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
  bool isExceedingLimit = false;
  @override
  void initState() {
    super.initState();
    caloriesPerGram = widget.calories / widget.servingSize;
    // Initialize serving units list with the custom gram unit based on widget.servingSize
    servingUnits = [
      ServingUnit(
          name: 'default',
          label: 'Default',
          grams: widget.servingSize,
          isDefault: true),
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
    selectedServingUnit = 'default';
    _servingsController.text = '1';
    _updateCalories('1');
    totalCalories = widget.calories;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealTypeBloc>().add(FetchMealTypes());
      context.read<MealTypeBloc>().add(SelectMealType(mealId: 'breakfast_id'));
    });
  }

  void _handleServingUnitChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedServingUnit = newValue;

        if (selectedServingUnit == 'default') {
          _servingsController.text = '1';
          _updateCalories('1');
          return;
        }
        // Reset quantity to 1 for all units except initial grams selection
        if (selectedServingUnit != 'g' ||
            numberOfServings != widget.servingSize) {
          _servingsController.text = '1';
          _updateCalories('1');
        }
      });
    }
  }

  void _updateCalories(String value) {
    setState(() {
      servingsError = null;
      isExceedingLimit = false;

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

      // if (selectedServingUnit == 'g') {
      //   _servingsController.text = widget.servingSize.toString();
      // }
      final ServingUnit unit = servingUnits.firstWhere(
        (u) => u.name == selectedServingUnit,
        orElse: () => servingUnits[0],
      );

      if (selectedServingUnit == 'default') {
        totalCalories = widget.calories * servings;
      } else if (selectedServingUnit == 'g') {
        totalCalories = caloriesPerGram * servings;
      } else {
        double gramsInSelectedServing = unit.grams * servings;
        totalCalories = caloriesPerGram * gramsInSelectedServing;
      }

      // Check if total calories exceed remaining limit
      final state = context.read<ProgressBarBloc>().state;
      if (state is ProgressBarLoaded) {
        final remainingCalories =
            state.data.dailyCalorieGoal - state.data.totalCaloriesConsumed;
        if (totalCalories > remainingCalories) {
          isExceedingLimit = true;
          servingsError = 'Exceeds daily calorie limit';
        }
      }
    });
  }

  @override
  void dispose() {
    _servingsController.dispose();
    super.dispose();
  }

  void _handleAddToMeal() {
    if (isExceedingLimit) {
      _showCalorieWarning(context);
      return;
    }
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
    if (!widget.isHistoryScreen) {
      context.read<AddCommonFoodHistoryBloc>().add(
            AddCommonFoodHistorySubmitted(
              userId: widget.userId,
              dishId: widget.productId,
            ),
          );
    }

    final request = CommonFoodRequest(
      userId: widget.userId,
      mealType: selectedMealType.toLowerCase(),
      servingSize: numberOfServings,
      selectedMeal: widget.productId,
      dishId: widget.productId,
      totalCalories: totalCalories,
    );

    context.read<CommonFoodBloc>().add(CommonFoodSubmitted(request));

    // ! for animating the calorie count
  }

  void _showCalorieWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Calorie Limit Warning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<ProgressBarBloc, ProgressBarState>(
                  builder: (context, state) {
                    if (state is ProgressBarLoaded) {
                      final remainingCalories = state.data.dailyCalorieGoal -
                          state.data.totalCaloriesConsumed;
                      return Text(
                        'This portion (${totalCalories.toStringAsFixed(1)} Cal) exceeds your remaining calorie limit (${remainingCalories.toStringAsFixed(1)} Cal) for today.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColors,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Understood',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return BlocBuilder<ProgressBarBloc, ProgressBarState>(
      builder: (context, progressState) {
        final bool isWithinLimit = progressState is ProgressBarLoaded
            ? totalCalories <=
                (progressState.data.dailyCalorieGoal -
                    progressState.data.totalCaloriesConsumed)
            : true;
        return MultiBlocListener(
          listeners: [
            BlocListener<CommonFoodBloc, CommonFoodState>(
              listener: (context, state) {
                if (state is CommonFoodSuccess) {
                  context.read<ProgressBarBloc>().add(FetchProgressBarData());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.response.message),
                      backgroundColor: Colors.green,
                      duration: const Duration(microseconds: 400),
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is CommonFoodFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            BlocListener<AddCommonFoodHistoryBloc, AddCommonFoodHistoryState>(
              listener: (context, state) {
                if (state is AddCommonFoodHistorySuccess) {
                  context.read<SearchHistoryLogBloc>().add(
                        GetSearchHistoryLogRequested(),
                      );
                } else if (state is AddCommonFoodHistoryFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
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
                      padding: EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        bottomPadding + 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Calories
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth * 0.6,
                                    child: Text(
                                      widget.mealName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSmallScreen ? 20 : 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Text(
                                    '${totalCalories.toStringAsFixed(1)} cal',
                                    style: TextStyle(
                                      color: isWithinLimit
                                          ? AppColors.buttonColors
                                          : Colors.red,
                                      fontSize: isSmallScreen ? 18 : 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.servingInfo,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Quantity and Serving Size inputs
                          Flex(
                            direction: screenSize.width > 480
                                ? Axis.horizontal
                                : Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: screenSize.width > 480 ? 2 : 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _servingsController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[800],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        errorText: servingsError,
                                        hintText: 'Enter quantity',
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: isSmallScreen ? 8 : 12,
                                        ),
                                      ),
                                      onChanged: _updateCalories,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenSize.width > 480 ? 0 : 16),
                              Flexible(
                                flex: screenSize.width > 480 ? 3 : 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Serving Size',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSmallScreen ? 14 : 16,
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
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: isSmallScreen ? 8 : 12,
                                          ),
                                          items: servingUnits
                                              .map((ServingUnit unit) {
                                            return DropdownMenuItem<String>(
                                              value: unit.name,
                                              child: Text(
                                                unit.label,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      isSmallScreen ? 12 : 14,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: _handleServingUnitChange,
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
                                        style:
                                            const TextStyle(color: Colors.red),
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
                                    Text(
                                      'Select Meal Type',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: EdgeInsets.all(
                                          isSmallScreen ? 8 : 12),
                                      child: Wrap(
                                        spacing: isSmallScreen ? 8 : 16,
                                        runSpacing: isSmallScreen ? 8 : 16,
                                        children:
                                            state.mealTypes.map((mealType) {
                                          bool isSelected =
                                              state.selectedMealId ==
                                                  mealType.id;
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
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    isSmallScreen ? 12 : 16,
                                                vertical: isSmallScreen ? 6 : 8,
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
                                                    size:
                                                        isSmallScreen ? 16 : 18,
                                                    color: isSelected
                                                        ? Colors.black
                                                        : Colors.grey,
                                                  ),
                                                  SizedBox(
                                                      width: isSmallScreen
                                                          ? 6
                                                          : 8),
                                                  Text(
                                                    mealType.meal,
                                                    style: TextStyle(
                                                      color: isSelected
                                                          ? Colors.black
                                                          : Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: isSmallScreen
                                                          ? 12
                                                          : 14,
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
                            height: isSmallScreen ? 40 : 50,
                            child: BlocBuilder<CommonFoodBloc, CommonFoodState>(
                              builder: (context, state) {
                                final bool isMealSelected =
                                    selectedMealType != 'CHOOSE';

                                return ElevatedButton(
                                  onPressed: (state is CommonFoodLoading ||
                                          !isWithinLimit ||
                                          !isMealSelected)
                                      ? null
                                      : _handleAddToMeal,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isMealSelected
                                        ? (isWithinLimit
                                            ? AppColors.buttonColors
                                            : Colors.grey)
                                        : Colors.grey[600],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: state is CommonFoodLoading
                                      ? const Center(
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppColors.buttonColors
                                                      ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          selectedMealType == 'CHOOSE'
                                              ? "SELECT MEAL TYPE"
                                              : 'ADD TO $selectedMealType',
                                          style: TextStyle(
                                            color: isMealSelected
                                                ? (isWithinLimit
                                                    ? Colors.black
                                                    : Colors.white)
                                                : Colors.white70,
                                            fontWeight: FontWeight.bold,
                                            fontSize: isSmallScreen ? 14 : 16,
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
