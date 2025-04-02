import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/cook_screen/ingredient_model.dart';

import 'pantry_cubit.dart';

class CookScreen extends StatelessWidget {
  const CookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PantryCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            // Fixed AppBar
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                'Pantry',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              elevation: 0,
            ),
            // Use a Column to structure the layout with fixed elements
            body: SafeArea(
              child: Column(
                children: [
                  // Scrollable content area that takes all available space
                  Expanded(
                    child: _buildScrollableContent(context),
                  ),
                  // Fixed bottom buttons section
                  _buildBottomButtons(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Scrollable content area
  Widget _buildScrollableContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Find the foods',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Header
            const Text(
              'What do you have in your pantry?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Selected Items Section
            BlocBuilder<PantryCubit, List<IngredientCategory>>(
              builder: (context, categories) {
                final selectedIngredients =
                    context.read<PantryCubit>().getAllSelectedIngredients();

                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.tileColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selected Items',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${selectedIngredients.length} ingredients',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_sweep,
                              color: Colors.red,
                              size: 30,
                            ),
                            onPressed: () {
                              context
                                  .read<PantryCubit>()
                                  .clearSelectedIngredients();
                            },
                          ),
                        ],
                      ),
                      if (selectedIngredients.isNotEmpty)
                        const SizedBox(height: 12),
                      if (selectedIngredients.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedIngredients.map((ingredient) {
                            return FilterChip(
                              selected: true,
                              showCheckmark: true,
                              checkmarkColor: Colors.black,
                              selectedColor:
                                  AppColors.buttonColors.withOpacity(0.8),
                              backgroundColor: Colors.grey[800],
                              label: Text(
                                ingredient.name,
                                style: const TextStyle(color: Colors.black),
                              ),
                              onSelected: (_) {
                                // Find the category this ingredient belongs to
                                for (final category in categories) {
                                  final index = category.ingredients.indexWhere(
                                      (i) =>
                                          i.name == ingredient.name &&
                                          i.isSelected);
                                  if (index != -1) {
                                    context
                                        .read<PantryCubit>()
                                        .toggleIngredient(
                                            category.name, ingredient.name);
                                    break;
                                  }
                                }
                              },
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Categories List
            BlocBuilder<PantryCubit, List<IngredientCategory>>(
              builder: (context, categories) {
                return ListView.builder(
                  // Make it work inside SingleChildScrollView by constraining its height
                  shrinkWrap: true,
                  // Disable ListView's scrolling since parent SingleChildScrollView handles it
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(context, category);
                  },
                );
              },
            ),

            // Add some bottom padding to ensure content isn't cut off by buttons
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Fixed bottom buttons section
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        // Add a subtle top border or shadow to separate from content
        border: Border(
          top: BorderSide(color: Color(0xFF222222), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Navigate to history screen
              },
              child: const Text(
                'History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColors,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Navigate to recipes screen
              },
              child: const Text(
                'See Recipes',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, IngredientCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Category header with toggle
          InkWell(
            onTap: () {
              context
                  .read<PantryCubit>()
                  .toggleCategoryExpansion(category.name);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${category.selectedCount}/${category.totalCount} ingredients',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    category.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // Ingredients list (chips)
          if (category.isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: _buildIngredientsGrid(context, category),
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: _buildCollapsedIngredientsGrid(context, category),
            ),
        ],
      ),
    );
  }

  Widget _buildIngredientsGrid(
      BuildContext context, IngredientCategory category) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: category.ingredients.map((ingredient) {
        return FilterChip(
          selected: ingredient.isSelected,
          showCheckmark: ingredient.isSelected,
          checkmarkColor: Colors.black,
          selectedColor: AppColors.buttonColors.withOpacity(0.8),
          backgroundColor: Colors.grey[800],
          label: Text(
            ingredient.name,
            style: TextStyle(
              color: ingredient.isSelected ? Colors.black : Colors.white,
            ),
          ),
          onSelected: (_) {
            context
                .read<PantryCubit>()
                .toggleIngredient(category.name, ingredient.name);
          },
        );
      }).toList()
        ..add(
          FilterChip(
            selected: false,
            backgroundColor: Colors.grey[800],
            label: const Text(
              '30+ More',
              style: TextStyle(color: Colors.white),
            ),
            onSelected: (_) {
              // Perhaps show a full-screen modal with all ingredients
            },
          ),
        ),
    );
  }

  Widget _buildCollapsedIngredientsGrid(
      BuildContext context, IngredientCategory category) {
    // Show only first 2 rows (about 6-8 items depending on screen size)
    final displayCount = 8;
    final displayedIngredients =
        category.ingredients.take(displayCount).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: displayedIngredients.map((ingredient) {
        return FilterChip(
          selected: ingredient.isSelected,
          showCheckmark: ingredient.isSelected,
          checkmarkColor: Colors.black,
          selectedColor: AppColors.buttonColors.withOpacity(0.8),
          backgroundColor: Colors.grey[800],
          label: Text(
            ingredient.name,
            style: TextStyle(
              color: ingredient.isSelected ? Colors.black : Colors.white,
            ),
          ),
          onSelected: (_) {
            context
                .read<PantryCubit>()
                .toggleIngredient(category.name, ingredient.name);
          },
        );
      }).toList()
        ..add(
          FilterChip(
            selected: false,
            backgroundColor: Colors.grey[800],
            label: const Text(
              '30+ More',
              style: TextStyle(color: Colors.white),
            ),
            onSelected: (_) {
              // Expand this category
              context
                  .read<PantryCubit>()
                  .toggleCategoryExpansion(category.name);
            },
          ),
        ),
    );
  }
}
