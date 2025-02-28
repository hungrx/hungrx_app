import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class DistanceDialog extends StatefulWidget {
  final double initialDistanceInMiles;
  final Function(double) onDistanceChanged;

  const DistanceDialog({
    super.key,
    this.initialDistanceInMiles = 3.1, // approximately 5000 meters
    required this.onDistanceChanged,
  });

  @override
  State<DistanceDialog> createState() => _DistanceDialogState();
}

class _DistanceDialogState extends State<DistanceDialog> {
  late TextEditingController distanceController;

  double _milesToMeters(double miles) {
    return miles * 1609.34; // 1 mile = 1609.34 meters
  }

  @override
  void initState() {
    super.initState();
    distanceController = TextEditingController();
  }

  @override
  void dispose() {
    distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.pin_drop,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 8),
          Text(
            'Search Range',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How far do you want to search?',
            style: TextStyle(color: Colors.grey[300], fontSize: 16),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: distanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Enter distance',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                Icons.route,
                color: Colors.grey[400],
              ),
              suffixText: 'miles',
              suffixStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tip: Use decimal values for precise distance (e.g., 1.5)',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            distanceController.clear(); // Clear the text field before popping
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonColors,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () {
            final distanceInMiles = double.tryParse(distanceController.text);
            if (distanceInMiles != null && distanceInMiles > 0) {
              final distanceInMeters = _milesToMeters(distanceInMiles);
              widget.onDistanceChanged(distanceInMeters);
              distanceController.clear(); // Clear the text field before popping
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Search range set to ${distanceInMiles.toStringAsFixed(1)} miles',
                    style: const TextStyle(fontSize: 16),
                  ),
                  backgroundColor: Colors.green[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(12),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Please enter a valid distance',
                    style: TextStyle(fontSize: 16),
                  ),
                  backgroundColor: Colors.red[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(12),
                ),
              );
            }
          },
          child: const Text(
            'Set Range',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}