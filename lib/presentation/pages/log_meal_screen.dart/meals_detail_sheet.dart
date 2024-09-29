import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class MealDetailsBottomSheet extends StatefulWidget {
  final String mealName;
  final String mealDescription;

  const MealDetailsBottomSheet({
    Key? key,
    required this.mealName,
    required this.mealDescription,
  }) : super(key: key);

  @override
  _MealDetailsBottomSheetState createState() => _MealDetailsBottomSheetState();
}

class _MealDetailsBottomSheetState extends State<MealDetailsBottomSheet> {
  int numberOfServings = 1;
  String servingSize = 'slice(xl)';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: AppColors.buttonColors, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.mealDescription,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                Text(
                  'Number of servings',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Container(
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
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Serving Size',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Container(
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
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement add to meal logic
                    Navigator.pop(context, {
                      'servings': numberOfServings,
                      'servingSize': servingSize,
                    });
                  },
                  child: Text(
                    'ADD TO BREAKFAST',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColors,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
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