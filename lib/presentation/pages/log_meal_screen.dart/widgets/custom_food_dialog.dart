import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/datasources/api/custom_food_entry_api.dart';
import 'package:hungrx_app/data/repositories/custom_food_entry_repository.dart';
import 'package:hungrx_app/domain/usecases/custom_food_entry_usecase.dart';
import 'package:hungrx_app/presentation/blocs/custom_food_entry/custom_food_entry_bloc.dart';
import 'package:hungrx_app/presentation/blocs/custom_food_entry/custom_food_entry_event.dart';
import 'package:hungrx_app/presentation/blocs/custom_food_entry/custom_food_entry_state.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_bloc.dart';
import 'package:hungrx_app/presentation/blocs/log_screen_meal_type/log_screen_meal_type_state.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_state.dart';

class CustomFoodDialog extends StatelessWidget {
  const CustomFoodDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          return BlocProvider(
            create: (context) => CustomFoodEntryBloc(
              CustomFoodEntryUseCase(
                CustomFoodEntryRepository(
                  CustomFoodEntryApi(),
                ),
              ),
            ),
            child: _CustomFoodDialogContent(userId: userState.userId ?? ""),
          );
        }
        // Show error if user is not authenticated
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Please log in to add custom food'),
          ),
        );
      },
    );
  }
}

class _CustomFoodDialogContent extends StatefulWidget {
  final String userId;

  const _CustomFoodDialogContent({
    required this.userId,
  });

  @override
  State<_CustomFoodDialogContent> createState() =>
      _CustomFoodDialogContentState();
}

class _CustomFoodDialogContentState extends State<_CustomFoodDialogContent> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedMealType;

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomFoodEntryBloc, CustomFoodEntryState>(
      listener: (context, state) {
        if (state is CustomFoodEntrySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, state.response);
        } else if (state is CustomFoodEntryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildFoodNameField(),
                  const SizedBox(height: 16),
                  _buildCaloriesField(),
                  const SizedBox(height: 16),
                  _buildMealTypeSelector(),
                  const SizedBox(height: 8),
                  _buildInfoText(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Add Custom Food',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFoodNameField() {
    return TextFormField(
      controller: _nameController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Food Name',
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter food name';
        }
        return null;
      },
    );
  }

  Widget _buildCaloriesField() {
    return TextFormField(
      controller: _caloriesController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Calories',
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter calories';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildMealTypeSelector() {
    return BlocBuilder<MealTypeBloc, MealTypeState>(
      builder: (context, state) {
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
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.mealTypes.map((mealType) {
                  bool isSelected = selectedMealType == mealType.id;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedMealType = mealType.id;
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
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? AppColors.buttonColors : Colors.grey,
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
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            mealType.meal,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.grey,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            'Search the calories from internet',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<CustomFoodEntryBloc, CustomFoodEntryState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: state is CustomFoodEntryLoading
                  ? null
                  : () => _handleSubmit(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColors,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state is CustomFoodEntryLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : const Text(
                      'Add Food',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (selectedMealType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a meal type'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<CustomFoodEntryBloc>().add(
            CustomFoodEntrySubmitted(
              userId: widget.userId,
              mealType: selectedMealType!,
              foodName: _nameController.text,
              calories: double.parse(_caloriesController.text),
            ),
          );
    }
  }
}
