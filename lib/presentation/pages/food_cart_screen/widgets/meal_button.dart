import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/food_cart_screen.dart/consume_cart_request.dart';
import 'package:hungrx_app/data/Models/home_meals_screen/meal_type.dart';
import 'package:hungrx_app/presentation/blocs/consume_cart/consume_cart_bloc.dart';
import 'package:hungrx_app/presentation/blocs/consume_cart/consume_cart_event.dart';
import 'package:hungrx_app/presentation/blocs/consume_cart/consume_cart_state.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_bloc.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_event.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_state.dart';
import 'package:hungrx_app/presentation/pages/food_cart_screen/widgets/success_dialog.dart';

class MealLoggerButton extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double borderRadius;

  final String totalCalories;
  final List<OrderDetail> orderDetails;

  const MealLoggerButton({
    super.key,
    this.buttonText = 'Consume',
    this.buttonColor = AppColors.buttonColors,
    this.textColor = Colors.black,
    this.borderRadius = 20,
    required this.totalCalories,
    required this.orderDetails,
  });

  @override
  State<MealLoggerButton> createState() => _MealLoggerButtonState();
}

class _MealLoggerButtonState extends State<MealLoggerButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showMealLogDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
      child: Text(
        widget.buttonText,
        style: TextStyle(color: widget.textColor),
      ),
    );
  }

  void _showMealLogDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return MealLogDialog(
          orderDetails: widget.orderDetails,
          totalCalories: widget.totalCalories,
        );
      },
    );
  }
}

class MealLogDialog extends StatelessWidget {
  final String totalCalories;
  final List<OrderDetail> orderDetails;
  const MealLogDialog({
    super.key,
    required this.totalCalories,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.grey[900],
      child: BlocListener<ConsumeCartBloc, ConsumeCartState>(
        listener: (context, state) {
          if (state is ConsumeCartSuccess) {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return SuccessDialog(
                  consumedCalories: totalCalories,
                  remainingCalories: state.response.updatedCalories.remaining.round()
                      .toString(), // Assuming you have this in your response
                );
              },
            );
          } else if (state is ConsumeCartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: MealLogContent(
          totalCalories: totalCalories,
          orderDetails: orderDetails,
        ),
      ),
    );
  }
}

class MealLogContent extends StatelessWidget {
  final String totalCalories;
  final List<OrderDetail> orderDetails;
  const MealLogContent({
    super.key,
    required this.totalCalories,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 10),
          _buildMealTypeSelector(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Log Your Meal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildMealTypeSelector() {
    return BlocBuilder<MealTypeBloc, MealTypeState>(
      builder: (context, state) {
        if (state is MealTypeLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.buttonColors,
            ),
          );
        }

        if (state is MealTypeLoaded) {
          return _buildMealTypeContent(context, state);
        }

        if (state is MealTypeError) {
          return _buildErrorContent(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMealTypeContent(BuildContext context, MealTypeLoaded state) {
    return Column(
      children: [
        _buildMealTypeGrid(context, state),
        const SizedBox(height: 15),
        _buildCaloriesInfo(),
        const SizedBox(height: 15),
        _buildConsumeButton(context, state),
      ],
    );
  }

  Widget _buildMealTypeGrid(BuildContext context, MealTypeLoaded state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chipWidth = (constraints.maxWidth - 18) / 2;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.start,
            children: state.mealTypes.map((mealType) {
              return _buildMealTypeChip(context, state, mealType, chipWidth);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildMealTypeChip(
    BuildContext context,
    MealTypeLoaded state,
    MealType mealType,
    double chipWidth,
  ) {
    bool isSelected = state.selectedMealId == mealType.id;
    return InkWell(
      onTap: () {
        context.read<MealTypeBloc>().add(SelectMealType(mealId: mealType.id));
      },
      child: Container(
        width: chipWidth,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.buttonColors : Colors.grey,
          ),
        ),
        child: _buildChipContent(isSelected, mealType, chipWidth),
      ),
    );
  }

  Widget _buildChipContent(
      bool isSelected, MealType mealType, double chipWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: chipWidth - 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            size: 24,
            color: isSelected ? AppColors.buttonColors : Colors.grey,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              mealType.meal,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesInfo() {
    return Row(
      children: [
        const SizedBox(width: 8),
        Text(
          'Total Calories: $totalCalories kcal',
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildConsumeButton(BuildContext context, MealTypeLoaded state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: BlocBuilder<ConsumeCartBloc, ConsumeCartState>(
        builder: (context, consumeCartState) {
          final isLoading = consumeCartState is ConsumeCartLoading;

          return ElevatedButton(
            onPressed: state.selectedMealId != null && !isLoading
                ? () {
                    context.read<ConsumeCartBloc>().add(
                          ConsumeCartSubmitted(
                            mealType: state.mealTypes
                                .firstWhere((m) => m.id == state.selectedMealId)
                                .meal
                                .toLowerCase(),
                            orderDetails: orderDetails,
                          ),
                        );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColors,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : state.selectedMealId != null
                    ? Text(
                        'CONSUME ${state.mealTypes.firstWhere((m) => m.id == state.selectedMealId).meal.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : const Text(
                        'SELECT A MEAL TYPE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
          );
        },
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, MealTypeError state) {
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
              context.read<MealTypeBloc>().add(FetchMealTypes());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
