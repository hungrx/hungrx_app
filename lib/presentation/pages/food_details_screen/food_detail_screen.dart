import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FoodDetailScreen extends StatelessWidget {
  final String foodName;
  final String imageUrl;
  final Map<String, double> nutritionFacts;
  final String description;

  const FoodDetailScreen({
    super.key,
    required this.foodName,
    required this.imageUrl,
    required this.nutritionFacts,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(foodName),

        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            imageUrl,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutritionIndicator("Carbohydrate", nutritionFacts['carbohydrate'] ?? 0, Colors.green),
                _buildNutritionIndicator("Fat", nutritionFacts['fat'] ?? 0, Colors.grey),
                _buildNutritionIndicator("Protein", nutritionFacts['protein'] ?? 0, Colors.grey),
                _buildNutritionIndicator("Cholestrol", nutritionFacts['cholesterol'] ?? 0, Colors.red),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "$foodName McDonald's",
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              description,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColors,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Implement add to cart functionality
              },
              child: const Text(
                'ADD',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionIndicator(String label, double value, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 30.0,
          lineWidth: 5.0,
          percent: value / 100, // Assuming the max value is 100
          center: Text(
            "${value.toInt()}g",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          progressColor: color,
          backgroundColor: Colors.grey[800]!,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}