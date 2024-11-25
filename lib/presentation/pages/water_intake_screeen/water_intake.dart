import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/dashboard_screen/widget/water_container.dart';

class WaterIntakeScreen extends StatefulWidget {
  const WaterIntakeScreen({super.key});

  @override
  WaterIntakeScreenState createState() => WaterIntakeScreenState();
}

class WaterIntakeScreenState extends State<WaterIntakeScreen> {
  double totalIntake = 2.1; // Total daily target in liters
  double consumedWater = 1.5; // Currently consumed water in liters
  List<WaterEntry> waterHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildWaterContainer(),
              const SizedBox(height: 40),
              _buildWaterCupOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOTAL DAILY INTAKE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '2.1L of water',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.history, color: Colors.white),
          onPressed: () => _showHistoryDialog(),
        ),
      ],
    );
  }

  Widget _buildWaterContainer() {
    return GestureDetector(
      onTap: () => _showHistoryDialog(),
      child: SizedBox(
        height: 300,
        width: 200,
        child: WaterContainer(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'REMAINING\n${(totalIntake - consumedWater).toStringAsFixed(1)}L',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'CONSUMED\n${consumedWater.toStringAsFixed(1)}L',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'DRINK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaterCupOptions() {
    List<Map<String, dynamic>> cups = [
      {'volume': 100, 'label': '100ml'},
      {'volume': 200, 'label': '200ml'},
      {'volume': 250, 'label': '250ml'},
      {'volume': 500, 'label': '500ml'},
      {'volume': 1000, 'label': '1000ml'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: cups.map((cup) => _buildCupButton(cup)).toList(),
    );
  }

  Widget _buildCupButton(Map<String, dynamic> cup) {
    return GestureDetector(
      onTap: () => _addWaterIntake(cup['volume']),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomPaint(
              painter: CupPainter(),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cup['label'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _addWaterIntake(int volume) {
    setState(() {
      double liters = volume / 1000;
      consumedWater = (consumedWater + liters).clamp(0.0, totalIntake);
      waterHistory.insert(
        0,
        WaterEntry(
          date: DateTime.now(),
          volume: volume,
        ),
      );
    });
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Water consumption',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: waterHistory.length,
                itemBuilder: (context, index) {
                  final entry = waterHistory[index];
                  return Dismissible(
                    key: Key(entry.date.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        waterHistory.removeAt(index);
                        // Recalculate consumed water
                        consumedWater = waterHistory.fold(
                          0.0,
                          (sum, entry) => sum + entry.volume / 1000,
                        );
                      });
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text(
                        '${entry.volume}ml',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        _formatDate(entry.date),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.delete, color: Colors.grey),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}';
  }
}

class CupPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.1, 0)
      ..lineTo(size.width * 0.9, 0)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaterEntry {
  final DateTime date;
  final int volume;

  WaterEntry({
    required this.date,
    required this.volume,
  });
}