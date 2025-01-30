import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/profile_screen/get_profile_details_model.dart';

class UserStatsDetailDialog extends StatelessWidget {
  final GetProfileDetailsModel profileData;

  const UserStatsDetailDialog({
    super.key,
    required this.profileData,
  });

  @override
  Widget build(BuildContext context) {
    print(profileData.height);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.buttonColors.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonColors.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildStats(),
              const SizedBox(height: 24),
              _buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.buttonColors,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Your Health Stats',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          profileData.name,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Column(
      children: [
        _buildSectionTitle('Basic Information'),
        _buildStatCard('Age', profileData.age),
        _buildStatCard('Gender', _capitalizeFirst(profileData.gender)),
        _buildStatCard('Height', profileData.height),
        const SizedBox(height: 16),
        
        _buildSectionTitle('Weight Management'),
        _buildStatCard('Current Weight', _formatWeight()),
        _buildStatCard('Target Weight', _formatTargetWeight()),
        _buildStatCard('Weight Goal', _capitalizeFirst(profileData.goal)),
        _buildStatCard('Days to Goal', '${profileData.daysToReachGoal} days'),
        const SizedBox(height: 16),
        
        _buildSectionTitle('Health Metrics'),
        _buildStatCard('BMI', '${profileData.bmi} (${_getBMICategory()})'),
        _buildStatCard('BMR', '${_formatCalories(profileData.bmr)} cal'),
        _buildStatCard('TDEE', '${_formatCalories(profileData.tdee)} cal'),
        const SizedBox(height: 16),
        
        _buildSectionTitle('Daily Goals'),
        _buildStatCard('Calorie Goal', _formatCalories(profileData.dailyCalorieGoal)),
        _buildStatCard('Water Intake', '${profileData.dailyWaterIntake} L'),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.buttonColors,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[850]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.buttonColors,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColors,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 2,
      ),
      child: const Text(
        'Close',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatWeight() {
    final weight = profileData.weight;
    final isMetric = profileData.isMetric;
    return '$weight ${isMetric ? 'kg' : 'lbs'}';
  }

  String _formatTargetWeight() {
    final weight = profileData.targetWeight;
    final isMetric = profileData.isMetric;
    return '$weight ${isMetric ? 'kg' : 'lbs'}';
  }

  String _formatCalories(String calories) {
    try {
      final cal = double.parse(calories);
      return '${cal.round()}';
    } catch (e) {
      return calories;
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _getBMICategory() {
    final bmi = double.tryParse(profileData.bmi) ?? 0;
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
}