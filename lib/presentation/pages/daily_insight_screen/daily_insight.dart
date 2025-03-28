import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/daily_insight_screen/daily_food_response.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_event.dart';
import 'package:hungrx_app/presentation/blocs/get_daily_insight_data/get_daily_insight_data_state.dart';
import 'package:hungrx_app/presentation/pages/daily_insight_screen/widget/food_delete_dialog.dart';
import 'package:hungrx_app/presentation/pages/daily_insight_screen/widget/nutiction_summery.dart';
import 'package:hungrx_app/presentation/pages/daily_insight_screen/widget/shimmer_effect.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyInsightScreen extends StatefulWidget {
  const DailyInsightScreen({super.key});

  @override
  DailyInsightScreenState createState() => DailyInsightScreenState();
}

class DailyInsightScreenState extends State<DailyInsightScreen> {
  late DateTime selectedDate;
  final List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  String? userId;
  DailyFoodResponse? cachedDailyInsight;
  bool isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    // Load user ID when screen initializes
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final date = DateFormat('dd/MM/yyyy').format(selectedDate);
    final cachedData = prefs.getString('daily_insight_cache');

    if (cachedData != null) {
      try {
        final decodedData = json.decode(cachedData) as Map<String, dynamic>;
        if (decodedData.containsKey(date)) {
          setState(() {
            cachedDailyInsight = DailyFoodResponse.fromJson(
                decodedData[date] as Map<String, dynamic>);
            isInitialLoad = false;
          });
        }
      } catch (e) {
        debugPrint('Error loading cached data: $e');
      }
    }

    // Fetch fresh data in background
    _fetchDailyInsightData();
  }

  void _fetchDailyInsightData() {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    context.read<DailyInsightBloc>().add(
          GetDailyInsightData(
            date: formattedDate,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<DailyInsightBloc, DailyInsightState>(
              listener: (context, state) {
                if (state is DailyInsightError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
          ],
          child: Column(
            children: [
              _buildHeader(),
              _buildDateSelector(),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Daily Insight',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 80,
      child: Row(
        children: [
          // Calendar picker button
          IconButton(
            onPressed: () => _showDatePicker(),
            icon: const Icon(Icons.calendar_today, color: Colors.white),
          ),
          // Horizontal date list
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index - 3));
                final isSelected = _isSameDay(date, selectedDate);
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedDate = date);
                    _fetchDailyInsightData();
                  },
                  child: Container(
                    width: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.buttonColors
                          : AppColors.tileColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weekDays[date.weekday % 7],
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.buttonColors,
              onPrimary: Colors.white,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[800],
            dialogTheme: const DialogTheme(
              titleTextStyle: TextStyle(color: Colors.white),
              contentTextStyle: TextStyle(color: Colors.white),
              backgroundColor: Colors.grey,
              surfaceTintColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && !_isSameDay(picked, selectedDate)) {
      setState(() => selectedDate = picked);
      _fetchDailyInsightData();
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildContent() {
    return BlocBuilder<DailyInsightBloc, DailyInsightState>(
      builder: (context, state) {
        if (state is DailyInsightLoading) {
          return const DailyInsightShimmer();
        }
        if (state is DailyInsightLoaded) {
          return _buildMealList(state.data);
        }
        if (state is DailyInsightError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _fetchDailyInsightData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColors,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildMealList(
    DailyFoodResponse data,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        NutritionSummary(
          dateTime: DateFormat('dd/MM/yyyy').format(selectedDate),
          consumedFood: data.consumedFood,
          dailySummary: data.dailySummary,
        ),
        // _buildCalorieProgress(data.dailySummary, data.consumedFood),
        _buildMealSection('Breakfast', data.consumedFood.breakfast.foods, data),
        _buildMealSection('Lunch', data.consumedFood.lunch.foods, data),
        _buildMealSection('Dinner', data.consumedFood.dinner.foods, data),
        _buildMealSection('Snacks', data.consumedFood.snacks.foods, data),
      ],
    );
  }

  Widget _buildMealSection(
      String title, List<FoodItem> foods, DailyFoodResponse data) {
    if (foods.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...foods.map((food) => _buildMealItem(food, data, title)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMealItem(FoodItem food, DailyFoodResponse data, String title) {
    // final formattedTime = DateFormat('hh:mm a').format(food.timestamp);
    final servingText = food.servingInfo != null
        ? '${food.servingInfo!.size} ${food.servingInfo!.unit}'
        : '${food.servingSize} serving';

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FoodDetailsDialog(
              mealTitle: title,
              date: data.date,
              consumedFood: data.consumedFood,
              userId: userId ?? "",
              food: food,
              // onDelete: (foodItem) {
              //   // Implement your delete logic here
              //   _showDeleteConfirmation(foodItem.name);
              // },
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fastfood, color: AppColors.buttonColors),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    servingText,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${food.totalCalories.toStringAsFixed(1)} Cal',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (food.brandName != null)
                  Text(
                    food.brandName!,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
