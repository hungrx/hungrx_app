import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/core/widgets/header_section.dart';
import 'package:hungrx_app/data/Models/weight_screen/weight_history_model.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_bloc.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_event.dart';
import 'package:hungrx_app/presentation/blocs/weight_track_bloc/weight_track_state.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightTrackingScreen extends StatefulWidget {
  const WeightTrackingScreen({
    super.key,
  });

  @override
  State<WeightTrackingScreen> createState() => _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends State<WeightTrackingScreen> {
  String? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id');
      isLoading = false;
    });

    // Fetch weight history when screen loads
    if (userId != null) {
      // ignore: use_build_context_synchronously
      context.read<WeightHistoryBloc>().add(FetchWeightHistory(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                _buildUpdateWeightButton(context),
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
      return const Center(child: CircularProgressIndicator());
    } else if (state is WeightHistoryLoaded) {
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildWeightGraph(state.weightHistory),
            _buildWeightEntries(state.weightHistory),
          ],
        ),
      );
    } else if (state is WeightHistoryNoRecords) {
      return _buildNoRecordsView();
    } else if (state is WeightHistoryError) {
      return _buildErrorView(context, state.message);
    }
    return const SizedBox();
  }

  Widget _buildWeightGraph(WeightHistoryModel weightHistory) {
    final List<ChartData> chartData = weightHistory.history
        .where((entry) =>
            entry.date != "Current Weight") // Filter out Current Weight
        .map((entry) => ChartData(entry.getGraphDate(), entry.weight))
        .toList();

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
          Text(
            'Current W: ${weightHistory.currentWeight}${weightHistory.isMetric ? 'kg' : 'lbs'}',
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(
                isInversed: true,
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

  Widget _buildWeightEntries(WeightHistoryModel weightHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Weight Entry',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(weightHistory.history.length, (index) {
          final entry = weightHistory.history[index];
          final previousWeight = index < weightHistory.history.length - 1
              ? weightHistory.history[index + 1].weight
              : entry.weight;
          final weightDiff = entry.weight - previousWeight;

          return _buildWeightEntryItem(
            entry.getFormattedDate(),
            '${entry.weight}${weightHistory.isMetric ? 'kg' : 'lbs'}',
            weightDiff,
            weightHistory.isMetric,
          );
        }),
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
              if (weightDiff != 0)
                Text(
                  isIncrease
                      ? 'Weight increased by $diffText${isMetric ? 'kg' : 'lbs'}'
                      : 'Weight decreased by $diffText${isMetric ? 'kg' : 'lbs'}',
                  style: TextStyle(
                    color: isIncrease ? Colors.red : Colors.green,
                    fontSize: 12,
                  ),
                ),
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
        onPressed: () async {
          final result = await context.pushNamed(RouteNames.weightPicker);
          if (result == true && userId != null) {
            // ignore: use_build_context_synchronously
            context.read<WeightHistoryBloc>().add(FetchWeightHistory(userId!));
          }
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

  Widget _buildNoRecordsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.scale_outlined,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'No Weight Records Found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your weight journey\nby adding your first weight record',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.goNamed(
                RouteNames.weightPicker,
                pathParameters: {'userId': userId!},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColors,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Add First Weight Record',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
