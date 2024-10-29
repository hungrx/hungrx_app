import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class UnitToggle extends StatelessWidget {
  final bool isMetric;
  final ValueChanged<bool> onToggle;

  const UnitToggle({
    super.key,
    required this.isMetric,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final toggleWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              // Animated background
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: isMetric ? toggleWidth : 0,
                child: Container(
                  width: toggleWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: AppColors.buttonColors,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              // Touch-sensitive buttons
              Row(
                children: [
                  _buildToggleButton(
                    label: 'Imperial',
                    isSelected: !isMetric,
                    onTap: () => onToggle(false),
                    constraints: constraints,
                  ),
                  _buildToggleButton(
                    label: 'Metric',
                    isSelected: isMetric,
                    onTap: () => onToggle(true),
                    constraints: constraints,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required BoxConstraints constraints,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          borderRadius: BorderRadius.circular(25),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            child: SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Text(label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
