import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class WeightReminderDialog extends StatelessWidget {
  final DateTime lastWeightUpdate;
  final double? currentWeight; // Add this parameter
  final bool isMaintain; // Add this parameter

  const WeightReminderDialog({
    super.key,
    required this.lastWeightUpdate,
    this.currentWeight, // Make it optional but recommended
    this.isMaintain = false, // Default to false if not provided
  });

  String _getTimeSinceLastUpdate() {
    final now = DateTime.now();
    final difference = now.difference(lastWeightUpdate);
    final days = difference.inDays;

    if (days == 0) return "today";
    if (days == 1) return "yesterday";
    return "$days days ago";
  }

  void _handleUpdateWeight(BuildContext context) {
    // Debugging
    // Ensure we always have a valid map for navigation
    final Map<String, dynamic> extraData = {
      'currentWeight': currentWeight ?? 0.0, // Provide a default if null
      'isMaintain': isMaintain,
    };

    Navigator.of(context).pop(true); // Close the dialog

    // Navigate to weight picker screen with the required data
    context.pushNamed(
      RouteNames.weightPicker,
      extra: extraData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.buttonColors.withOpacity(0.8),
                    AppColors.buttonColors,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                LucideIcons.scale,
                size: 40,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Weekly Weight Check',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your last weight update was ${_getTimeSinceLastUpdate()}. Would you like to update your weight now?',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[300],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Remind Later',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleUpdateWeight(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColors,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Update Now',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
