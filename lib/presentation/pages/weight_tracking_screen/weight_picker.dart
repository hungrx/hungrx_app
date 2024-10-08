import 'package:flutter/material.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class WeightPickerScreen extends StatefulWidget {
  const WeightPickerScreen({super.key});

  @override
  WeightPickerScreenState createState() => WeightPickerScreenState();
}

class WeightPickerScreenState extends State<WeightPickerScreen> {
  String selectedValue = ''; // Default weight

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 350, bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: AnimatedWeightPicker(
                  showSelectedValue: false,
                  dialColor: Colors.white,
                  dialHeight: 70,
                  division: 0.1,
                  majorIntervalHeight: 24,
                  majorIntervalColor: Colors.red,
                  minorIntervalHeight: 14,
                  selectedValueColor: AppColors.buttonColors,
                  min: 0,
                  max: 200,
                  onChange: (newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                selectedValue,
                style: const TextStyle(
                    fontSize: 74,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Handle weight submission

                  // You can navigate back or process the weight here
                  Navigator.of(context).pop(selectedValue);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColors,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
