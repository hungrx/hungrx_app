import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/food_details_screen/food_detail_screen.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/meals_detail_sheet.dart';

class LogMealScreen extends StatefulWidget {
  const LogMealScreen({super.key});

  @override
  LogMealScreenState createState() => LogMealScreenState();
}

class LogMealScreenState extends State<LogMealScreen> {
  String selectedMealType = 'Breakfast';
  String sortOption = 'Recently Added';

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text('Log your meal', style: TextStyle(color: Colors.white)),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            // const SizedBox(height: 20),
            _buildMealTypeSelector(),
            // const SizedBox(height: 20),
            _buildHistoryHeader(),
            // If _buildFoodList() returns a ListView, modify it like this:
            SizedBox(
              // Set a fixed height or calculate based on screen size
              height: MediaQuery.of(context).size.height * 0.6, // Example: 60% of screen height
              child: _buildFoodList(),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(30),
            
            border: Border.all(color: Colors.grey, width: 1,),
            
          ),
          child: const TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search foods or scan',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

Widget _buildMealTypeSelector() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Meal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['Breakfast', 'Lunch', 'Snacks', 'Dinner'].map((type) {
            bool isSelected = selectedMealType == type;
            return GestureDetector(
              onTap: () => setState(() => selectedMealType = type),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.buttonColors : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.buttonColors,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

  Widget _buildHistoryHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('History',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(),
            child: DropdownButton<String>(
              dropdownColor: Colors.black,
              value: sortOption,
              icon: const Icon(Icons.arrow_drop_down,
                  color: AppColors.buttonColors),
              style:  const TextStyle(color: Colors.grey),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                setState(() {
                  sortOption = newValue!;
                });
              },
              items: <String>[
                'Recently Added',
                'Alphabetical',
                'Calories: High to Low',
                'Calories: Low to High'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    
    return ListView.builder(
      shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
      itemCount: 12, 
      itemBuilder: (context, index) {
        return _buildFoodItem('Boiled Egg', '1.0 cup (chopped)', '590 Cal.');
      },
    );
  }

  Widget _buildFoodItem(String name, String description, String calories) {
    return GestureDetector(
      onTap: () {
                Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FoodDetailScreen(
              foodName: 'Boiled egg',
              imageUrl: 'assets/images/burger.png',
              nutritionFacts: {
                'carbohydrate': 46,
                'fat': 34,
                'protein': 25,
                'cholesterol': 85,
              },
              description:
                  "boiled egg with big eggs and full of protiens ...",
            ),
          ),
        );
        
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            Row(
              children: [
                Text(calories, style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _showMealDetailsBottomSheet(context, name, description);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_circle_outline,
                        color: AppColors.buttonColors, size: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMealDetailsBottomSheet(
      BuildContext context, String name, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: MealDetailsBottomSheet(
              mealName: name,
              mealDescription: description,
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        // Handle the returned data (number of servings and serving size)
        print(
            'Servings: ${value['servings']}, Serving Size: ${value['servingSize']}');
        // Implement your logic to add the meal to the user's log
      }
    });
  }

// ... (rest of the LogMealScreen code)
}
