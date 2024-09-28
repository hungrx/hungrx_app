import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WeightTrackingScreen extends StatelessWidget {
  const WeightTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildWeightGraph(),
                    _buildWeightEntries(),
                  ],
                ),
              ),
            ),
            _buildUpdateWeightButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {}, // Implement navigation
          ),
          const Text(
            'Weight Tracking',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightGraph() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current W: 75Kg',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData:  FlGridData(show: true, drawVerticalLine: true, drawHorizontalLine: true),
                titlesData: FlTitlesData(
                  // leftTitles:  SideTitles(showTitles: true, reservedSize: 30),
                  // bottomTitles: SideTitles(
                  //   showTitles: true,
                  //   getTitles: (value) {
                  //     switch (value.toInt()) {
                  //       case 0:
                  //         return 'Jan 10';
                  //       case 2:
                  //         return 'Mar 20';
                  //       case 4:
                  //         return 'Jun 10';
                  //       default:
                  //         return '';
                  //     }
                  //   },
                  // ),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.white, width: 1)),
                minX: 0,
                maxX: 5,
                minY: 20,
                maxY: 50,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 32),
                      const FlSpot(1, 33),
                      const FlSpot(2, 35),
                      const FlSpot(3, 42),
                      const FlSpot(4, 45),
                    ],
                    isCurved: true,
                    // spots: [Colors.green],
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightEntries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Weight Entry',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildWeightEntryItem('12-jun-20234', '50KG', '3kg'),
        _buildWeightEntryItem('12-jun-20234', '45KG', '3kg'),
        _buildWeightEntryItem('12-jun-20234', '42KG', '3kg'),
        _buildWeightEntryItem('12-jun-20234', '35KG', '3kg'),
        _buildWeightEntryItem('12-jun-20234', '35KG', '3kg'),
      ],
    );
  }

  Widget _buildWeightEntryItem(String date, String weight, String weightLoss) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              Text(date, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('Total weight lose : $weightLoss', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text(weight, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildUpdateWeightButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Implement weight update logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Update Weight',
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}