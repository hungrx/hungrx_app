import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/request_restaurant/request_restaurant_bloc.dart';
import 'package:hungrx_app/presentation/blocs/request_restaurant/request_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/request_restaurant/request_restaurant_state.dart';

class RequestRestaurantDialog extends StatelessWidget {
  const RequestRestaurantDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantNameController = TextEditingController();
    final restaurantTypeController = TextEditingController();
    final areaController = TextEditingController();

    return BlocListener<RequestRestaurantBloc, RequestRestaurantState>(
      listener: (context, state) {
        if (state is RequestRestaurantSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Restaurant request submitted successfully')),
          );
        } else if (state is RequestRestaurantFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Increased border curve
        ),
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(24), // Increased padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Request New Restaurant',
                style: TextStyle(
                  color: Colors.white, // Changed to white for better visibility
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: restaurantNameController,
                labelText: 'Restaurant Name',
                icon: Icons.restaurant,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: restaurantTypeController,
                labelText: 'Restaurant Type',
                icon: Icons.category,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: areaController,
                labelText: 'Area',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 28), // Increased spacing
              _buildButtons(
                context,
                restaurantNameController,
                restaurantTypeController,
                areaController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white, // Text color while typing
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[400], // Label text color
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.buttonColors, // Icon color matching button color
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.buttonColors, width: 2), // Active border color matching button color
        ),
        filled: true,
        fillColor: Colors.grey[900],
      ),
    );
  }

  Widget _buildButtons(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController typeController,
    TextEditingController areaController,
  ) {
    return BlocBuilder<RequestRestaurantBloc, RequestRestaurantState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: state is RequestRestaurantLoading
                  ? null
                  : () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.buttonColors,
                  fontWeight: FontWeight.w600, // Added weight for better visibility
                ),
              ),
            ),
            ElevatedButton(
              onPressed: state is RequestRestaurantLoading
                  ? null
                  : () {
                      context.read<RequestRestaurantBloc>().add(
                            SubmitRequestRestaurantEvent(
                              restaurantName: nameController.text,
                              restaurantType: typeController.text,
                              area: areaController.text,
                            ),
                          );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColors,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2, // Added elevation for better depth
              ),
              child: state is RequestRestaurantLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600, // Added weight for better visibility
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}