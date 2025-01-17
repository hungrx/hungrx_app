import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/eat_screen/eat_screen_model.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_state.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_state.dart';
import 'package:hungrx_app/routes/route_names.dart';

class EatScreen extends StatefulWidget {
  const EatScreen({super.key});

  @override
  State<EatScreen> createState() => _EatScreenState();
}

class _EatScreenState extends State<EatScreen> {
  String? userId;
  EatScreenData? _cachedData;

  @override
  void initState() {
    super.initState();
    _loadEatScreenData();
  }

  void _loadEatScreenData() {
    context.read<EatScreenBloc>().add(GetEatScreenDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (userId != null) {
              _loadEatScreenData();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocConsumer<EatScreenBloc, EatScreenState>(
              listener: (context, state) {
                if (state is EatScreenLoaded) {
                  _cachedData = state.data.data;
                } else if (state is EatScreenError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      action: SnackBarAction(
                        label: 'Retry',
                        onPressed: () {
                          if (userId != null) {
                            _loadEatScreenData();
                          }
                        },
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                String value = _cachedData?.dailyCalorieGoal ?? "0";
                double parsedValue = double.tryParse(value) ?? 0.0;
                String result = parsedValue.round().toString();
                // or if you want to keep it as a double with no decimal places:
                // String result = parsedValue.toStringAsFixed(0);

                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(_cachedData),
                        const SizedBox(height: 20),
                        _buildSearchBar(context),
                        const SizedBox(height: 20),
                        _buildCalorieBudget(result),
                        const SizedBox(height: 20),
                        _buildOptionsGrid(),
                        const Spacer(),
                        _buildEnjoyCalories(),
                      ],
                    ),
                    // Show loading overlay only during initial load
                    if (state is EatScreenLoading && _cachedData == null)

                      // _buildLoadingOverlay(),{}
                      // Show error overlay only during initial load failure
                      if (state is EatScreenError && _cachedData == null)
                        _buildErrorOverlay("An error occurred")
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorOverlay(String message) {
    return Container(
      color: AppColors.tileColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (userId != null) {
                  _loadEatScreenData();
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(EatScreenData? data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hi, ${data?.name ?? 'User'}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return BlocBuilder<EatScreenSearchBloc, EatScreenSearchState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.tileColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            onTap: () {
              // Navigate to search screen when the search bar is tapped
              context.pushNamed(RouteNames.eatScreenSearch);
            },
            readOnly: true, // Make it non-editable in this view
            decoration: InputDecoration(
              hintText: 'Search your food',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: state is SearchLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalorieBudget(String dailyCalorieGoal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dailyCalorieGoal,
          style: const TextStyle(
              color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
        ),
        const Text(
          'calorie budget per day',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildOptionsGrid() {
    return Row(
      children: [
        Expanded(
            child: _buildOptionCard(
          'Restaurants',
          'Discover Nearby Restaurant Menus That Fit Your Calorie Budget',
          'assets/images/burger.png',
          () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const RestaurantScreen()),
            // );
            context.pushNamed(RouteNames.restaurants);
          },
        )),
        const SizedBox(width: 16),
        Expanded(
            child: _buildOptionCard(
          'Home',
          'Log what you eat from home or grocery stores for better calorie management.',
          'assets/images/piza.png',
          () {
            context.pushNamed(RouteNames.logMealScreen);
          },
        )),
      ],
    );
  }

  Widget _buildOptionCard(
      String title, String subtitle, String imagePath, void Function()? ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnjoyCalories() {
    return Text(
      'Enjoy\nCalories!',
      style: TextStyle(
          color: Colors.grey[800], fontSize: 66, fontWeight: FontWeight.bold),
    );
  }
}
