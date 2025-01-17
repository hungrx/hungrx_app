import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/Models/water_screen/get_water_entry_model.dart';
import 'package:hungrx_app/presentation/blocs/delete_water/delete_water_bloc.dart';
import 'package:hungrx_app/presentation/blocs/delete_water/delete_water_event.dart';
import 'package:hungrx_app/presentation/blocs/delete_water/delete_water_state.dart';
import 'package:hungrx_app/presentation/blocs/get_water_entry/get_water_entry_bloc.dart';
import 'package:hungrx_app/presentation/blocs/get_water_entry/get_water_entry_event.dart';
import 'package:hungrx_app/presentation/blocs/get_water_entry/get_water_entry_state.dart';
import 'package:hungrx_app/presentation/blocs/water_intake/water_intake_bloc.dart';
import 'package:hungrx_app/presentation/blocs/water_intake/water_intake_event.dart';
import 'package:hungrx_app/presentation/blocs/water_intake/water_intake_state.dart';
import 'package:hungrx_app/presentation/pages/water_intake_screeen/widgets/water_dialog.dart';
import 'package:hungrx_app/presentation/pages/water_intake_screeen/widgets/water_shimmer.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WaterIntakeScreen extends StatefulWidget {
  const WaterIntakeScreen({super.key});

  @override
  State<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends State<WaterIntakeScreen> {
  late DateTime selectedDate;
  final List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWaterIntakeData();
    });
  }

  void _loadWaterIntakeData() {
    if (!mounted) return;
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    context.read<GetWaterIntakeBloc>().add(
          FetchWaterIntakeData(
            date: formattedDate,
          ),
        );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener for DeleteWaterBloc
        BlocListener<DeleteWaterBloc, DeleteWaterState>(
          listener: (context, state) {
            if (state is DeleteWaterIntakeLoading) {
              const WaterIntakeShimmer();
            } else if (state is DeleteWaterIntakeSuccess) {
              _showSnackBar('Water intake deleted successfully');
              // Reload water intake data after successful deletion
              _loadWaterIntakeData();
            } else if (state is DeleteWaterIntakeError) {
              _showSnackBar(state.message, isError: true);
            }
          },
        ),
        // Listener for WaterIntakeBloc (Add Water)
        BlocListener<WaterIntakeBloc, WaterIntakeState>(
          listener: (context, state) {
            if (state is WaterIntakeLoading) {
              const WaterIntakeShimmer();
            } else if (state is WaterIntakeSuccess) {
              _showSnackBar('Water intake added successfully');
              // Reload water intake data after successful addition
              _loadWaterIntakeData();
            } else if (state is WaterIntakeFailure) {
              _showSnackBar(state.message, isError: true);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocConsumer<GetWaterIntakeBloc, GetWaterIntakeState>(
            listener: (context, state) {
              if (state is GetWaterIntakeError) {
                _showSnackBar(state.message, isError: true);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  _buildHeader(),
                  _buildDateSelector(),
                  if (state is GetWaterIntakeLoading)
                    const WaterIntakeShimmer()
                  else if (state is GetWaterIntakeLoaded)
                    Expanded(
                      child: _buildMainContent(state.data),
                    )
                  else
                    const WaterIntakeShimmer()
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
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
            'Water Intake',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // IconButton(
          //   icon: const Icon(Icons.more_vert, color: Colors.white),
          //   onPressed: () {
          //     // Show options menu
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildMainContent(WaterIntakeData data) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildWaterProgress(data),
                _buildIntakeHistory(data.dateStats.entries),
              ],
            ),
          ),
        ),
        _buildQuickAddButtons(),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isSelected = _isSameDay(date, selectedDate);
          return GestureDetector(
            onTap: () {
              setState(() => selectedDate = date);
              _loadWaterIntakeData();
            },
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.lightBlueAccent : AppColors.tileColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    weekDays[date.weekday % 7],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaterProgress(WaterIntakeData data) {
    final dailyGoal = double.parse(data.dailyWaterIntake) * 1000;
    final consumedAmount = data.dateStats.totalIntake.toDouble();
    final progress =
        dailyGoal > 0 ? (consumedAmount / dailyGoal).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 80,
            lineWidth: 10,
            percent: progress,
            center: const Icon(
              Icons.water_drop,
              color: Colors.lightBlueAccent,
              size: 40,
            ),
            progressColor: Colors.lightBlueAccent,
            backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressItem(
                  Icons.flag,
                  'Goal',
                  '${data.dailyWaterIntake} Liter',
                ),
                const SizedBox(height: 12),
                _buildProgressItem(
                  Icons.water_drop_outlined,
                  'Remaining',
                  '${(data.dateStats.remaining / 1000).toStringAsFixed(2)} L',
                ),
                const SizedBox(height: 12),
                _buildProgressItem(
                  Icons.check_circle_outline,
                  'Consumed',
                  '${data.dateStats.totalIntake} ml',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.lightBlueAccent, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntakeHistory(List<WaterIntakeEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Intake History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          itemCount: entries.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            // Reverse the index to show newest entries first
            final reversedIndex = entries.length - 1 - index;
            final intake = entries[reversedIndex];
            DateTime utcTime = DateTime.parse(intake.timestamp.toString());
            DateTime localTime = utcTime.toLocal();

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tileColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(localTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        // Update the intake number to match the original order
                        "No of Intake :${(entries.length - reversedIndex).toString()}",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${intake.amount} ml',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.grey),
                        onPressed: () {
                          _deleteWaterEntry(intake.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _deleteWaterEntry(String entryId) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title:
              const Text('Delete Entry', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to delete this water intake entry?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<DeleteWaterBloc>().add(
                      DeleteWaterIntakeEntry(
                        date: formattedDate,
                        entryId: entryId,
                      ),
                    );
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickAddButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWaterButton(100),
              _buildWaterButton(200),
              _buildWaterButton(250),
              _buildWaterButton(500),
              _buildWaterButton(1000),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add, color: Colors.lightBlueAccent),
              label: const Text('Drink',
                  style: TextStyle(color: Colors.lightBlueAccent)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.lightBlueAccent),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _showAddWaterDialog();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddWaterDialog() {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: WaterIntakeDialog(
            amountController: amountController,
            onCancel: () {
              amountController.dispose();
              Navigator.pop(context);
            },
            onAdd: (int amount) {
              if (amount > 0) {
                context.read<WaterIntakeBloc>().add(
                      AddWaterIntake(
                        amount: amount.toString(),
                      ),
                    );
              }

              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Widget _buildWaterButton(int amount) {
    return InkWell(
      onTap: () {
        context.read<WaterIntakeBloc>().add(
              AddWaterIntake(
                amount: amount.toString(),
              ),
            );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop, color: Colors.blue),
          ),
          const SizedBox(height: 4),
          Text(
            '${amount}ml',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class WaterIntake {
  final DateTime timestamp;
  final int amount;

  WaterIntake(this.timestamp, this.amount);
}
