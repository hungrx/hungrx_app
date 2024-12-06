import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/daily_food_response.dart';
import 'package:hungrx_app/presentation/blocs/foodConsumedDelete/food_consumed_delete_bloc.dart';
import 'package:hungrx_app/presentation/blocs/foodConsumedDelete/food_consumed_delete_event.dart';
import 'package:hungrx_app/presentation/blocs/foodConsumedDelete/food_consumed_delete_state.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_event.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_state.dart';
import 'package:intl/intl.dart';

class FoodDetailsDialog extends StatelessWidget {
  final String mealTitle;
  final FoodItem food;
  final String userId;
  final ConsumedFood consumedFood;
  final String date;

  const FoodDetailsDialog({
    super.key,
    required this.food,
    required this.userId,
    required this.consumedFood,
    required this.date,
    required this.mealTitle,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteFoodBloc, DeleteFoodState>(
          listener: (context, state) {
            if (state is DeleteFoodSuccess) {
              Navigator.of(context).pop();
              context.read<DailyInsightBloc>().add(
                    GetDailyInsightData(
                      userId: userId,
                      date: date,
                    ),
                  );
              _showSnackBar(
                context: context,
                message: state.response.message,
                isError: false,
              );
            } else if (state is DeleteFoodFailure) {
              _showSnackBar(
                context: context,
                message: state.error,
                isError: true,
              );
            }
          },
        ),
        BlocListener<DailyInsightBloc, DailyInsightState>(
          listener: (context, state) {
            // Optional: Handle loading states or errors
            if (state is DailyInsightError) {
              _showSnackBar(
                context: context,
                message: "Failed to refresh data: ${state.message}",
                isError: true,
              );
            }
          },
        ),
      ],
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          constraints: const BoxConstraints(
            maxWidth: 500,
            minWidth: 300,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.tileColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: BlocBuilder<DeleteFoodBloc, DeleteFoodState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildFoodDetails(),
                  const SizedBox(height: 24),
                  // _buildNutritionalInfo(),
                  // const SizedBox(height: 24),
                  _buildActionButtons(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildFoodImage(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (food.brandName != null) ...[
                const SizedBox(height: 4),
                Text(
                  food.brandName!,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[900],
      ),
      child: food.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                food.image!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildFallbackIcon(),
              ),
            )
          : _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return const Icon(
      Icons.restaurant,
      color: AppColors.primaryColor,
      size: 40,
    );
  }

  Widget _buildFoodDetails() {
    final formattedTime = DateFormat('hh:mm a').format(food.timestamp);
    final servingText = food.servingInfo != null
        ? '${food.servingInfo!.size} ${food.servingInfo!.unit}'
        : '${food.servingSize} serving';

    return Column(
      children: [
        _buildDetailRow('Time Consumed', formattedTime),
        _buildDetailRow('Serving Size', servingText),
        _buildDetailRow(
            'Total Calories', '${food.totalCalories.toStringAsFixed(1)} Cal'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, DeleteFoodState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: state is DeleteFoodLoading
              ? null
              : () => _showDeleteConfirmationDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: state is DeleteFoodLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.tileColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete ${food.name}?',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to remove ${food.name} from your meal list? This action cannot be undone.',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                String mealIds;
                Navigator.of(context).pop();
                if (mealTitle == "Breakfast") {
                  mealIds = consumedFood.breakfast.mealId;
                } else if (mealTitle == "Dinner") {
                  mealIds = consumedFood.dinner.mealId;
                } else if (mealTitle == "Snacks") {
                  mealIds = consumedFood.snacks.mealId;
                } else {
                  mealIds = consumedFood.lunch.mealId;
                }
                print(mealIds);
                print(userId);
                print(date);

                context.read<DeleteFoodBloc>().add(
                      DeleteConsumedFoodRequested(
                        userId: userId,
                        date: date,
                        mealId: mealIds,
                        dishId: food.dishId,
                      ),
                    );
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar({
    required BuildContext context,
    required String message,
    required bool isError,
  }) {
    // Remove any existing SnackBars
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // Create the SnackBar
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.1,
        left: 16,
        right: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
      // action: SnackBarAction(
      //   label: 'Dismiss',
      //   textColor: Colors.white,
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   },
      // ),
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
