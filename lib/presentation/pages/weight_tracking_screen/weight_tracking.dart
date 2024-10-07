import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/weight_picker.dart';
import 'package:hungrx_app/core/widgets/header_section.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightTrackingScreen extends StatelessWidget {
  const WeightTrackingScreen({super.key});

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
            _buildUpdateWeightButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const HeaderSection(
      title: 'Weight Tracking',
    );
  }

  Widget _buildWeightGraph() {
    final List<ChartData> chartData = [
      ChartData("Mar", 35),
      ChartData("Jun", 28),
      ChartData("Jul", 34),
      ChartData("Aug", 32),
      ChartData("Sep", 40),
      ChartData("Oct", 45)
    ];
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SfCartesianChart(
            
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 1),
                labelStyle: TextStyle(color: Colors.white),
              ),
              primaryYAxis: const NumericAxis(
                majorGridLines: MajorGridLines(width: 1),
                labelStyle: TextStyle(color: Colors.white),
              ),
              plotAreaBorderWidth: 0,
              series: <CartesianSeries>[
                LineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: AppColors.buttonColors,
                  width: 3,
                  dashArray: const <double>[5, 5],
                  markerSettings: const MarkerSettings(isVisible: true),
                )
              ],
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
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
              Text(date,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text('Total weight lose : $weightLoss',
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text(weight,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildUpdateWeightButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WeightPickerScreen()),
          );
          // Implement weight update logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColors,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Update Weight',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
