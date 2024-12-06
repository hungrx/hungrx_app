import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/food_item_model.dart';
import 'package:hungrx_app/data/Models/get_search_history_log_response.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_state.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/widgets/meals_detail_sheet.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FoodDetailScreen extends StatefulWidget {
  final bool isSearchScreen;
  final GetSearchHistoryLogItem? searchFood;
  final FoodItemModel? foodItem;

  const FoodDetailScreen({
    super.key,
    required this.isSearchScreen,
    this.searchFood,
    this.foodItem,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool _isFavorite = false;

  // Getter methods to handle both models
  String get name => widget.isSearchScreen
      ? widget.searchFood?.name ?? 'Unknown'
      : widget.foodItem?.name ?? 'Unknown';

  String get brand => widget.isSearchScreen
      ? widget.searchFood?.brandName ?? 'Unknown'
      : widget.foodItem?.brand ?? 'Unknown';

  String? get image =>
      widget.isSearchScreen ? widget.searchFood?.image : widget.foodItem?.image;

  String get itemId => widget.isSearchScreen
      ? widget.searchFood?.foodId ?? ''
      : widget.foodItem?.itemId ?? '';

  double get calories => widget.isSearchScreen
      ? widget.searchFood?.nutritionFacts.calories ?? 0.0
      : widget.foodItem?.nutritionFacts.calories ?? 0.0;

  String? get category =>
      widget.isSearchScreen ? "unkown" : widget.foodItem?.category?.main;

  String? get calorieBurnNote => widget.isSearchScreen
      ? "No discription"
      : widget.foodItem?.calorieBurnNote;

// Nutrition facts getter
  NutritionFacts get nutritionFacts {
    if (widget.isSearchScreen && widget.searchFood != null) {
      final searchNutrition = widget.searchFood!.nutritionFacts;
      return NutritionFacts(
        calories: double.tryParse(searchNutrition.calories.toString()) ?? 0.0,
        totalFat: searchNutrition.totalFat != null
            ? NutrientValue(
                value: searchNutrition.totalFat!.value ?? 0,
                unit: searchNutrition.totalFat!.unit ?? 'g',
              )
            : null,
        saturatedFat: searchNutrition.saturatedFat != null
            ? NutrientValue(
                value: searchNutrition.saturatedFat!.value ?? 0,
                unit: searchNutrition.saturatedFat!.unit ?? 'g',
              )
            : null,
        totalCarbohydrates: searchNutrition.totalCarbohydrates != null
            ? NutrientValue(
                value: searchNutrition.totalCarbohydrates!.value ?? 0,
                unit: searchNutrition.totalCarbohydrates!.unit ?? 'g',
              )
            : null,
        dietaryFiber: searchNutrition.dietaryFiber != null
            ? NutrientValue(
                value: searchNutrition.dietaryFiber!.value ?? 0,
                unit: searchNutrition.dietaryFiber!.unit ?? 'g',
              )
            : null,
        sugars: searchNutrition.sugars != null
            ? NutrientValue(
                value: searchNutrition.sugars!.value ?? 0,
                unit: searchNutrition.sugars!.unit ?? 'g',
              )
            : null,
        protein: searchNutrition.protein != null
            ? NutrientValue(
                value: searchNutrition.protein!.value ?? 0,
                unit: searchNutrition.protein!.unit ?? 'g',
              )
            : null,
        potassium: searchNutrition.potassium != null
            ? NutrientValue(
                value: searchNutrition.potassium!.value ?? 0,
                unit: searchNutrition.potassium!.unit ?? 'mg',
              )
            : null,
      );
    } else if (!widget.isSearchScreen && widget.foodItem != null) {
      return widget.foodItem!.nutritionFacts;
    }

    // Return default NutritionFacts if no data is available
    return NutritionFacts(
      calories: 0.0,
      totalFat: null,
      saturatedFat: null,
      cholesterol: null,
      sodium: null,
      totalCarbohydrates: null,
      dietaryFiber: null,
      sugars: null,
      addedSugars: null,
      protein: null,
      potassium: null,
    );
  }

// Serving information getter
  ServingInfo? get servingInfo {
    if (widget.isSearchScreen && widget.searchFood?.servingInfo != null) {
      final searchServing = widget.searchFood!.servingInfo;
      return ServingInfo(
        size: searchServing.size ?? 0,
        unit: searchServing.unit ?? '',
      );
    } else if (!widget.isSearchScreen && widget.foodItem?.servingInfo != null) {
      return widget.foodItem!.servingInfo;
    }
    return null;
  }

// Add this class if you haven't already

  String get servingSizeText {
    return '${servingInfo?.size ?? "unknown"}';
  }
    String get servingUnitText {
    return servingInfo?.unit ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderSection(),
                  _buildServingInformation(),
                  _buildNutritionFactsCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'food_image_$itemId',
              child: image != null
                  ? Image.network(
                      image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [_buildFavoriteButton()],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[800],
      child: const Icon(
        Icons.restaurant,
        size: 80,
        color: Colors.white54,
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? Colors.red : Colors.white,
        ),
      ),
      onPressed: () => setState(() => _isFavorite = !_isFavorite),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 280,
                          child: Text(
                            name,
                            style: const TextStyle(
                              overflow: TextOverflow.clip,
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '${calories.toInt()} cal',
                          style: const TextStyle(
                            color: AppColors.buttonColors,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      brand,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (category == 'Vegetarian')
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.5)),
                  ),
                  child: const Icon(Icons.eco, color: Colors.green),
                ),
            ],
          ),
          if (calorieBurnNote != null) ...[
            const SizedBox(height: 16),
            Text(
              calorieBurnNote!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildNutritionIndicators(),
        ],
      ),
    );
  }

  Widget _buildNutritionIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (nutritionFacts.totalCarbohydrates != null)
          _buildNutritionIndicator(
            "Carbs",
            nutritionFacts.totalCarbohydrates!.value,
            Colors.green,
            300.0,
          ),
        if (nutritionFacts.protein != null)
          _buildNutritionIndicator(
            "Protein",
            nutritionFacts.protein!.value,
            Colors.blue,
            50.0,
          ),
        if (nutritionFacts.totalFat != null)
          _buildNutritionIndicator(
            "Fat",
            nutritionFacts.totalFat!.value,
            Colors.orange,
            65.0,
          ),
      ],
    );
  }

  Widget _buildNutritionIndicator(
    String label,
    double value,
    Color color,
    double maxValue,
  ) {
    double normalizedValue = (value / maxValue).clamp(0.0, 1.0);
    double percentage = (value / maxValue * 100).clamp(0.0, 100.0);

    return Tooltip(
      message: '${percentage.toInt()}% of daily value',
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 35.0,
            lineWidth: 5.0,
            percent: normalizedValue,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  nutritionFacts.totalCarbohydrates?.unit ?? 'g',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            progressColor: color,
            backgroundColor: Colors.grey[800]!,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionFactsCard() {
    final facts = nutritionFacts;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nutrition Facts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.grey, thickness: 2),
          _buildNutritionRow('Calories', facts.calories.toInt(), 'kcal', true),
          if (facts.totalFat != null)
            _buildNutritionRow(
              'Total Fat',
              facts.totalFat!.value.toInt(),
              facts.totalFat!.unit,
              true,
            ),
          if (facts.saturatedFat != null)
            _buildNutritionRow(
              'Saturated Fat',
              facts.saturatedFat!.value.toInt(),
              facts.saturatedFat!.unit,
              false,
            ),
          if (facts.totalCarbohydrates != null)
            _buildNutritionRow(
              'Total Carbohydrates',
              facts.totalCarbohydrates!.value.toInt(),
              facts.totalCarbohydrates!.unit,
              true,
            ),
          if (facts.dietaryFiber != null)
            _buildNutritionRow(
              'Dietary Fiber',
              facts.dietaryFiber!.value.toInt(),
              facts.dietaryFiber!.unit,
              false,
            ),
          if (facts.sugars != null)
            _buildNutritionRow(
              'Sugars',
              facts.sugars!.value.toInt(),
              facts.sugars!.unit,
              false,
            ),
          if (facts.protein != null)
            _buildNutritionRow(
              'Protein',
              facts.protein!.value.toInt(),
              facts.protein!.unit,
              true,
            ),
          if (facts.sodium != null)
            _buildNutritionRow(
              'Sodium',
              facts.sodium!.value.toInt(),
              facts.sodium!.unit,
              false,
            ),
          if (facts.potassium != null)
            _buildNutritionRow(
              'Potassium',
              facts.potassium!.value.toInt(),
              facts.potassium!.unit,
              false,
            ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(
    String label,
    int value,
    String unit,
    bool showDivider,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                '$value$unit',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(color: Colors.grey),
      ],
    );
  }

  Widget _buildServingInformation() {
    if (servingInfo == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Serving Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Serving Size',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              Text(
                servingSizeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Serving Unit',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              Text(
                servingUnitText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          _showMealDetailsBottomSheet(
            context,
            name,
            servingSizeText,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColors,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'ADD TO MEAL',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showMealDetailsBottomSheet(
    BuildContext context,
    String name,
    String description,
  ) {
    final foodData =
        widget.isSearchScreen ? widget.searchFood : widget.foodItem;
    if (foodData == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: MealDetailsBottomSheet(
                productId: itemId,
                userId: userState.userId ??
                    "", // Assuming this is correct for your use case
                calories: calories,
                mealName: name,
                servingInfo: description,
              ),
            ),
          );
        });
      },
    ).then((value) {
      if (value != null) {
        debugPrint(
          'Servings: ${value['servings']}, Serving Size: ${value['servingSize']}',
        );
      }
    });
  }

  @override
  void dispose() {
    // Add any cleanup logic here if needed
    super.dispose();
  }
}

class NutrientValues {
  final double value;
  final String unit;

  NutrientValues({
    required this.value,
    required this.unit,
  });
}
