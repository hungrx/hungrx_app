import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/eat_screen/eat_screen_model.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_state.dart';
import 'package:hungrx_app/presentation/pages/eat_screen/widgets/shimmer_effect.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:material_symbols_icons/symbols.dart';

class EatScreen extends StatefulWidget {
  const EatScreen({super.key});

  @override
  State<EatScreen> createState() => _EatScreenState();
}

class _EatScreenState extends State<EatScreen> {
  String? userId;
  EatScreenData? _cachedData;

  void _loadEatScreenData() {
    context.read<EatScreenBloc>().add(GetEatScreenDataEvent());
  }

  String _formatCalories(String value) {
    double parsedValue = double.tryParse(value) ?? 0.0;
    return parsedValue.round().toString();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            if (state is EatScreenInitial) {
              context.read<EatScreenBloc>().add(GetEatScreenDataEvent());
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadEatScreenData();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_cachedData != null || state is EatScreenLoaded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeader((state is EatScreenLoaded)
                                    ? state.data.data
                                    : _cachedData!),
                                SizedBox(height: size.height * 0.02),
                                _buildCalorieBudget(_formatCalories(
                                    (state is EatScreenLoaded)
                                        ? state.data.data.dailyCalorieGoal
                                        : _cachedData!.dailyCalorieGoal)),
                                SizedBox(height: size.height * 0.05),
                                _buildOptionsGrid(size),
                              ],
                            )
                          else
                            _buildPlaceholderContent(),
                          const Spacer(),
                          _buildEnjoyCalories(size),
                          if (state is EatScreenError && _cachedData == null)
                            _buildErrorOverlay("An error occurred"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    return const EatScreenShimmer();
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

  Widget _buildOptionsGrid(Size size) {
    return Row(
      children: [
        Expanded(
          child: _buildOptionCard(
            'Restaurants',
            'Discover Nearby Restaurant Menus That Fit Your Calorie Budget',
            'assets/images/burger.png',
            Icons.fastfood_outlined,
            () {
              context.pushNamed(RouteNames.restaurants);
            },
            size,
          ),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          child: _buildOptionCard(
            'Home',
            'Log what you eat from home or grocery stores for better calorie management.',
            'assets/images/piza.png',
            Symbols.skillet,
            () {
              context.pushNamed(RouteNames.logMealScreen);
            },
            size,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    String title,
    String subtitle,
    String imagePath,
    IconData? icon,
    void Function()? ontap,
    Size size,
  ) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: size.height * 0.35,
        padding: EdgeInsets.all(size.width * 0.04),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey,
                fontSize: size.width * 0.03,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Center(
              child: Icon(
                icon,
                // Icons.fastfood_outlined,
                color: AppColors.buttonColors,
                size: 110,
              ),
            )
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: SizedBox(
            //     height: size.height * 0.15,
            //     width: double.infinity,
            //     child: Image.asset(
            //       imagePath,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnjoyCalories(Size size) {
    return Text(
      'Enjoy\nCalories!',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: size.width * 0.15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
