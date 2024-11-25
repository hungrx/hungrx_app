import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_bloc.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_event.dart';
import 'package:hungrx_app/presentation/blocs/home_screen/home_screen_state.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/dashboard_widgets.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/streak_map.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/water_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungrx_app/routes/route_names.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  double totalCalories = 115300;
  int selectedIndex = 0;

  // void _showDrinkBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: AppColors.tileColor,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => Container(
  //       padding: const EdgeInsets.all(10),
  //       child: const Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             'Add Water Intake',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           // Add your water intake UI here
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(RefreshHomeData());
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DashboardWidgets.buildHeader(state.homeData, context),
                        const SizedBox(height: 16),
                        DashboardWidgets.buildCalorieCounter(state.homeData),
                        const SizedBox(height: 16),
                        DashboardWidgets.buildDailyTargetAndRemaining(
                            state.homeData, context),
                        const SizedBox(height: 16),
                        _buildStreakCalendar(),
                        const SizedBox(height: 16),
                        _buildDrinkButton(),
                        const SizedBox(height: 16),
                        DashboardWidgets.buildBottomButtons(
                            context, state.homeData),
                        // ... rest of your widgets
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

 



  Widget _buildStreakCalendar() {
    return const StreakCalendar(
    );
  }

  Widget _buildDrinkButton() {
    return GestureDetector(
      onTap: (){
        context.pushNamed(RouteNames.waterIntake);
      },
      child: Container(
        height: 100, // Add fixed height for better animation
        // padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: WaterContainer(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Water',
                  style: GoogleFonts.stickNoBills(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.local_drink, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }


 
}
