import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class MealDetailsBottomSheet extends StatefulWidget {
  final String mealName;
  final String mealDescription;

  const MealDetailsBottomSheet({
    super.key,
    required this.mealName,
    required this.mealDescription,
  });

  @override
  MealDetailsBottomSheetState createState() => MealDetailsBottomSheetState();
}

class MealDetailsBottomSheetState extends State<MealDetailsBottomSheet> {
  int numberOfServings = 1;
  String servingSize = 'slice(xl)';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: AppColors.buttonColors, width: 2),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mealName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.mealDescription,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Number of servings',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: CupertinoPicker(
                    backgroundColor: Colors.transparent,
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        numberOfServings = index + 1;
                      });
                    },
                    children: List.generate(10, (index) {
                      return Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Serving Size',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: CupertinoPicker(
                    backgroundColor: Colors.transparent,
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        servingSize = ['slice(xl)', 'grams', 'cup'][index];
                      });
                    },
                    children: ['slice(xl)', 'grams', 'cup'].map((size) {
                      return Center(
                        child: Text(
                          size,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement add to meal logic
                    Navigator.pop(context, {
                      'servings': numberOfServings,
                      'servingSize': servingSize,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColors,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'ADD TO BREAKFAST',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}