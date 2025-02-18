import 'package:flutter/material.dart';
// import 'package:hungrx_app/presentation/pages/subcription_screen/subscription_screen.dart';
// import 'package:hungrx_app/presentation/pages/subcription_screen/subscription_screen.dart';

class PremiumContainer extends StatelessWidget {
 final void Function()? onpress ;

  const PremiumContainer({super.key, this.onpress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade900,
            Colors.indigo.shade900,
            Colors.blue.shade900,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Get Hungrx Premium",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Unlock all features, track your calories, reach your goal weight",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
  
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
               onPressed: () => onpress!(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Get Now",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}