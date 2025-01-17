import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class UnitToggle extends StatefulWidget {
  final bool isMetric;
  final ValueChanged<bool> onToggle;

  const UnitToggle({
    super.key,
    required this.isMetric,
    required this.onToggle,
  });

  @override
  State<UnitToggle> createState() => _UnitToggleState();
}

class _UnitToggleState extends State<UnitToggle> {
  late bool _isMetric;

  @override
  void initState() {
    super.initState();
    _isMetric = widget.isMetric;
  }

  @override
  void didUpdateWidget(UnitToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMetric != widget.isMetric) {
      _isMetric = widget.isMetric;
    }
  }

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
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: _isMetric ? toggleWidth : 0,
                child: Container(
                  width: toggleWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: AppColors.buttonColors,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              Row(
                children: [
                  _buildToggleButton(
                    label: 'Imperial',
                    isSelected: !_isMetric,
                    onTap: () {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        widget.onToggle(false);
                      });
                    },
                    constraints: constraints,
                  ),
                  _buildToggleButton(
                    label: 'Metric',
                    isSelected: _isMetric,
                    onTap: () {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        widget.onToggle(true);
                      });
                    },
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
