import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/eat_screen/eat_screen_model.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_state.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:shimmer/shimmer.dart';

class EatScreen extends StatefulWidget {
  const EatScreen({super.key});

  @override
  State<EatScreen> createState() => _EatScreenState();
}

class _EatScreenState extends State<EatScreen> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String? userId;
  EatScreenData? _cachedData;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadEatScreenData();
  // }

  void _loadEatScreenData() {
    context.read<EatScreenBloc>().add(GetEatScreenDataEvent());
  }

  String _formatCalories(String value) {
    double parsedValue = double.tryParse(value) ?? 0.0;
    return parsedValue.round().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocConsumer<EatScreenBloc, EatScreenState>(
          listener: (context, state) {
            if (state is EatScreenError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  action: SnackBarAction(
                    label: 'Retry',
                    onPressed: _loadEatScreenData,
                  ),
                ),
              );
            } else if (state is EatScreenLoaded) {
              _cachedData = state.data.data;
            }
          },
          builder: (context, state) {
            // Trigger data load on first build if no data exists
            if (state is EatScreenInitial) {
              context.read<EatScreenBloc>().add(GetEatScreenDataEvent());
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadEatScreenData();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        // Removed extra Padding
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_cachedData != null || state is EatScreenLoaded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeader((state is EatScreenLoaded)
                                    ? state.data.data
                                    : _cachedData!),
                                const SizedBox(height: 10),
                                _buildCalorieBudget(_formatCalories(
                                    (state is EatScreenLoaded)
                                        ? state.data.data.dailyCalorieGoal
                                        : _cachedData!.dailyCalorieGoal)),
                                const SizedBox(height: 50),
                                _buildOptionsGrid(),
                              ],
                            )
                          else
                            _buildPlaceholderContent(),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  _buildEnjoyCalories(),
                  if (state is EatScreenLoading && _cachedData == null)
                    // const Center(
                    //   child: CircularProgressIndicator(),
                    // ),
                    if (state is EatScreenError && _cachedData == null)
                      _buildErrorOverlay("An error occurred"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer for header
          Container(
            width: 200,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 40),
          // Shimmer for calorie budget
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 180,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
          // Shimmer for options grid
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
              onPressed: _loadEatScreenData,
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
