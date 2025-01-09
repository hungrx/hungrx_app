import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/presentation/pages/water_intake_screeen/widgets/water_dialog.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WaterIntakeScreen extends StatefulWidget {
  const WaterIntakeScreen({super.key});

  @override
  WaterIntakeScreenState createState() => WaterIntakeScreenState();
}

class WaterIntakeScreenState extends State<WaterIntakeScreen> {
  late DateTime selectedDate;
  final List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  double goalAmount = 2000; // 2 Liter in ml
  double consumedAmount = 800; // Current consumed amount in ml
  List<WaterIntake> intakeHistory = [];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    // Initialize dummy data
    intakeHistory = [
      WaterIntake(DateTime.now(), 200),
      WaterIntake(DateTime.now(), 200),
      WaterIntake(DateTime.now(), 200),
      WaterIntake(DateTime.now(), 200),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header section
            _buildHeader(),
            // Fixed date selector
            _buildDateSelector(),
            // Scrollable middle content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildWaterProgress(),
                    _buildIntakeHistory(),
                  ],
                ),
              ),
            ),
            // Fixed bottom buttons
            _buildQuickAddButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 16,right: 16, top: 10,bottom: 10),
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
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.only(left: 16,right: 16, bottom: 10),
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isSelected = _isSameDay(date, selectedDate);
          return GestureDetector(
            onTap: () => setState(() => selectedDate = date),
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.lightBlueAccent : Colors.grey[900],
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

  Widget _buildWaterProgress() {
    final remainingAmount = goalAmount - consumedAmount;
    final progress = (consumedAmount / goalAmount).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
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
                  '${(goalAmount / 1000).toStringAsFixed(1)} Liter',
                ),
                const SizedBox(height: 12),
                _buildProgressItem(
                  Icons.water_drop_outlined,
                  'Remaining',
                  '${(remainingAmount / 1000).toStringAsFixed(1)} L',
                ),
                const SizedBox(height: 12),
                _buildProgressItem(
                  Icons.check_circle_outline,
                  'Consumed',
                  '${consumedAmount.toInt()} ml',
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

  Widget _buildIntakeHistory() {
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
          itemCount: intakeHistory.length,
          shrinkWrap: true, // Important for nested ListView
          physics: const NeverScrollableScrollPhysics(), // Disable ListView's scroll
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final intake = intakeHistory[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd- MMMM - yyyy').format(intake.timestamp),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('hh:mm a').format(intake.timestamp),
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
                          setState(() {
                            intakeHistory.removeAt(index);
                          });
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
    builder: (BuildContext context) {
      return WaterIntakeDialog(
        amountController: amountController,
        onCancel: () => Navigator.pop(context),
        onAdd: (int amount) {
          setState(() {
            consumedAmount += amount;
            intakeHistory.insert(
              0,
              WaterIntake(DateTime.now(), amount),
            );
          });
          Navigator.pop(context);
        },
      );
    },
  );
}

  Widget _buildWaterButton(int amount) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.water_drop, color: Colors.blue),
          onPressed: () {
            setState(() {
              consumedAmount += amount;
              intakeHistory.insert(0, WaterIntake(DateTime.now(), amount));
            });
          },
        ),
        Text(
          '${amount}ml',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
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
