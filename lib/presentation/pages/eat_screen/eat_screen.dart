import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/Models/eat_screen/eat_screen_model.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_state.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/get_eat_screen/get_eat_screen_state.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_bloc.dart';
import 'package:hungrx_app/presentation/blocs/user_id_global/user_id_state.dart';
import 'package:hungrx_app/presentation/pages/log_meal_screen.dart/log_meal_screen.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/restaurant_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = context.read<UserBloc>().state;
      if (userState.userId != null) {
        setState(() {
          userId = userState.userId;
        });
        _loadEatScreenData(userState.userId!);
      }
    });
  }

  void _loadEatScreenData(String userId) {
    context.read<EatScreenBloc>().add(GetEatScreenDataEvent(userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state.userId != null && state.userId != userId) {
                  setState(() {
                    userId = state.userId;
                  });
                  _loadEatScreenData(state.userId!);
                }
              },
            ),
          ],
          child: RefreshIndicator(
            onRefresh: () async {
              if (userId != null) {
                _loadEatScreenData(userId!);
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
                              _loadEatScreenData(userId!);
                            }
                          },
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  // Show loading indicator only if userId is null
                  if (userId == null) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(_cachedData),
                            const SizedBox(height: 20),
                            _buildSearchBar(context),
                            const SizedBox(height: 20),
                            _buildCalorieBudget(
                                _cachedData?.dailyCalorieGoal ?? '0'),
                            const SizedBox(height: 20),
                            _buildOptionsGrid(),
                            _buildEnjoyCalories(),
                          ],
                        ),
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
      ),
    );
  }

  // Widget _buildLoadingOverlay() {
  //   return Container(
  //     color: Colors.black.withOpacity(0.5),
  //     child: const Center(
  //       child: CircularProgressIndicator(
  //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildErrorOverlay(String message) {
    return Container(
      color: Colors.black.withOpacity(0.8),
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
                  _loadEatScreenData(userId!);
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
        // const CircleAvatar(
        //   radius: 25,
        //   backgroundImage: AssetImage('assets/images/dp.png') as ImageProvider,
          
        //   // data?.profilePhoto != null
        //   //     ? NetworkImage(data!.profilePhoto!)
        //   //     : const AssetImage('assets/images/dp.png') as ImageProvider,
        // ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return BlocBuilder<EatScreenSearchBloc, EatScreenSearchState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RestaurantScreen()),
            );
          },
        )),
        const SizedBox(width: 16),
        Expanded(
            child: _buildOptionCard(
          'Home',
          'Log what you eat from home or grocery stores for better calorie management.',
          'assets/images/piza.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogMealScreen()),
            );
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
          color: Colors.grey[900],
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
