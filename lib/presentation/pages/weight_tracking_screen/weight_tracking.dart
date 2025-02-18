import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/core/widgets/header_section.dart';
import 'package:hungrx_app/data/Models/weight_screen/weight_history_model.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_state.dart';
import 'package:hungrx_app/presentation/pages/weight_tracking_screen/widget/shimmer_effect.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightTrackingScreen extends StatefulWidget {
  final bool isMaintain;
  const WeightTrackingScreen({
    super.key,
    required this.isMaintain,
  });

  @override
  State<WeightTrackingScreen> createState() => _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends State<WeightTrackingScreen> {
  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    context.read<WeightHistoryBloc>().add(FetchWeightHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocBuilder<WeightHistoryBloc, WeightHistoryState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildContent(context, state),
                ),
                _buildUpdateWeightButton(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const HeaderSection(
      title: 'Weight Tracking',
    );
  }

  Widget _buildContent(BuildContext context, WeightHistoryState state) {
    if (state is WeightHistoryLoading) {
      return const WeightTrackingShimmer();
    } else if (state is WeightHistoryLoaded) {
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildWeightGraph(state.weightHistory),
            _buildWeightEntries(state.weightHistory),
          ],
        ),
      );
    } else if (state is WeightHistoryError) {
      return _buildErrorView(context, state.message);
    }
    return const SizedBox();
  }

  Widget _buildWeightGraph(WeightHistoryModel weightHistory) {
    final List<ChartData> chartData = [];

    // Sort history by date before creating chart data
    final sortedHistory = List.from(weightHistory.history)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Add initial weight as the first point
    chartData.add(ChartData('Initial', weightHistory.initialWeight));

    // Add rest of the weight entries
    chartData.addAll(sortedHistory
        .where((entry) => entry.date != null)
        .map((entry) => ChartData(entry.getGraphDate(), entry.weight))
        .toList());

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      height: 280, // Increased height for better visibility
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Initial W: ${weightHistory.initialWeight}${weightHistory.isMetric ? 'kg' : 'lbs'}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Current: ${weightHistory.currentWeight}${weightHistory.isMetric ? 'kg' : 'lbs'}',
                style: const TextStyle(
                    color: AppColors.buttonColors,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SfCartesianChart(

              margin: const EdgeInsets.all(0),
              primaryXAxis: CategoryAxis(
                isInversed: false,
                majorGridLines:
                    const MajorGridLines(width: 0.5, color: Colors.grey),
                labelStyle: const TextStyle(color: Colors.white),
                // labelRotation: 45, // Rotate labels for better readability
                interval: 1,
              ),
              primaryYAxis: NumericAxis(
                autoScrollingMode: AutoScrollingMode.end,
                majorGridLines:
                    const MajorGridLines(width: 0.5, color: Colors.grey),
                labelStyle: const TextStyle(color: Colors.white),
                minimum: _getMinWeight(weightHistory) - 1,
                maximum: _getMaxWeight(weightHistory) + 1,
                interval: 2, // Set interval for better readability
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: Colors.grey[800],
                textStyle: const TextStyle(color: Colors.white),
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
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 8,
                    width: 8,
                    color: AppColors.buttonColors,
                    borderColor: Colors.white,
                    borderWidth: 2,
                  ),
                  enableTooltip: true,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getMinWeight(WeightHistoryModel weightHistory) {
    double minWeight = weightHistory.initialWeight;
    for (var entry in weightHistory.history) {
      if (entry.weight < minWeight) {
        minWeight = entry.weight;
      }
    }
    return minWeight;
  }

  double _getMaxWeight(WeightHistoryModel weightHistory) {
    double maxWeight = weightHistory.initialWeight;
    for (var entry in weightHistory.history) {
      if (entry.weight > maxWeight) {
        maxWeight = entry.weight;
      }
    }
    return maxWeight;
  }

  Widget _buildWeightEntries(WeightHistoryModel weightHistory) {
    // Sort entries by date in descending order (newest first)
    final sortedEntries = List.from(weightHistory.history)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weight History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${sortedEntries.length} entries',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedEntries.length,
          itemBuilder: (context, index) {
            final entry = sortedEntries[index];
            final previousWeight = index < sortedEntries.length - 1
                ? sortedEntries[index + 1].weight
                : weightHistory.initialWeight;
            final weightDiff = entry.weight - previousWeight;

            return _buildWeightEntryItem(
              entry.getFormattedDate(),
              '${entry.weight}${weightHistory.isMetric ? 'kg' : 'lbs'}',
              weightDiff,
              weightHistory.isMetric,
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeightEntryItem(
      String date, String weight, double weightDiff, bool isMetric) {
    final isIncrease = weightDiff > 0;
    final diffText = weightDiff.abs().toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                if (weightDiff != 0)
                  Text(
                    isIncrease
                        ? '↑ Increased by $diffText${isMetric ? 'kg' : 'lbs'}'
                        : '↓ Decreased by $diffText${isMetric ? 'kg' : 'lbs'}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
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

  Widget _buildUpdateWeightButton(
      BuildContext context, WeightHistoryState state) {
    if (state is WeightHistoryLoaded) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.pushNamed(
              RouteNames.weightPicker,
              extra: {
                'currentWeight': state
                    .weightHistory.currentWeight, // your current weight value
                'isMaintain': widget.isMaintain,
              },
            );
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
    return const SizedBox();
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_emotions,
            size: 60,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No weight History available',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
