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
                    hasScrollBody: true, // Changed to true to allow scrolling
                    child: SingleChildScrollView(
                      // Added SingleChildScrollView to fix overflow
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
                                  SizedBox(height: size.height * 0.02),
                                  _buildOptionsGrid(size),
                                ],
                              )
                            else
                              _buildPlaceholderContent(),
                            SizedBox(height: size.height * 0.02),
                            _buildEnjoyCalories(size),
                            if (state is EatScreenError && _cachedData == null)
                              _buildErrorOverlay("An error occurred"),
                          ],
                        ),
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
            fontSize: 28,
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
    final tileWidth = size.width * 0.45;
    final tileHeight = size.height * 0.25;

    return Wrap(
      spacing: size.width * 0.04,
      runSpacing: size.height * 0.02,
      children: [
        // Restaurant tile
        _buildSmallTile(
          size: size,
          width: tileWidth,
          height: tileHeight,
          title: 'Restaurants',
          subtitle:
              'Discover Nearby Restaurant Menus That Fit Your Calorie Budget',
          icon: Icons.fastfood_outlined,
          iconColor: AppColors.buttonColors,
          onTap: () {
            context.pushNamed(RouteNames.restaurants);
          },
        ),

        // Home tile
        _buildSmallTile(
          size: size,
          width: tileWidth,
          height: tileHeight,
          title: 'Home',
          subtitle:
              'Log what you eat from home or grocery stores for better calorie management.',
          icon: Symbols.home_app_logo,
          iconColor: AppColors.buttonColors,
          onTap: () {
            context.pushNamed(RouteNames.logMealScreen);
          },
        ),

        // Cook tile with badge
        _buildSmallTile(
          size: size,
          width: tileWidth,
          height: tileHeight,
          title: 'Cook',
          subtitle: 'Create a meal in 5 mins, ai integrated feature',
          icon: Symbols.skillet,
          iconColor: AppColors.buttonColors,
          showBadge: true, // Enable the badge
          badgeText: 'NEW', // Set badge text
          badgeColor: Colors.green, // Set badge color
          onTap: () {
            context.pushNamed(RouteNames.cookScreen);
            // context.pushNamed(RouteNames.cookScreen);
          },
        ),
      ],
    );
  }

  Widget _buildSmallTile({
    required Size size,
    required double width,
    required double height,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool showBadge = false,
    String badgeText = 'New',
    Color badgeColor = Colors.green,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        // Wrap with Stack to overlay the badge
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.tileColor,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: EdgeInsets.all(size.width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: size.width * 0.025,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 100,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
              ],
            ),
          ),
          // Badge element that only shows if showBadge is true
          if (showBadge)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
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
