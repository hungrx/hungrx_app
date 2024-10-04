import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  BasicInformationScreenState createState() => BasicInformationScreenState();
}

class BasicInformationScreenState extends State<BasicInformationScreen> {
  String gender = 'Male';
  final TextEditingController nameController = TextEditingController(text: 'Werren Daniel');
  final TextEditingController phoneController = TextEditingController(text: '87956426599');
  final TextEditingController emailController = TextEditingController(text: 'warrentdaniel@gmail.com');
  final TextEditingController ageController = TextEditingController(text: '25');
  final TextEditingController weightController = TextEditingController(text: '100');
  final TextEditingController targetWeightController = TextEditingController(text: '25');
  final TextEditingController goalPaceController = TextEditingController(text: '25');
  final TextEditingController heightController = TextEditingController(text: '25');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Basic Information', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              // Implement save functionality
              Navigator.of(context).pop();
            },
            child: const Text('Done', style: TextStyle(color: AppColors.buttonColors)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputField(Icons.person, 'Name', nameController),
            const SizedBox(height: 16),
            _buildGenderSelector(),
            const SizedBox(height: 16),
            _buildInputField(Icons.phone, 'Phone number', phoneController),
            const SizedBox(height: 16),
            _buildInputField(Icons.email, 'Email', emailController),
            const SizedBox(height: 16),
            _buildInputField(Icons.cake, 'Age', ageController),
            const SizedBox(height: 16),
            _buildInputField(Icons.monitor_weight, 'Weight', weightController, suffix: 'kg'),
            const SizedBox(height: 16),
            _buildInputField(Icons.monitor_weight_outlined, 'Target Weight', targetWeightController, suffix: 'kg'),
            const SizedBox(height: 16),
            _buildInputField(Icons.flag, 'Goal pace', goalPaceController, suffix: 'kg'),
            const SizedBox(height: 16),
            _buildInputField(Icons.height, 'Height', heightController, suffix: 'cm'),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String label, TextEditingController controller, {String? suffix}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.buttonColors),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                labelStyle: const TextStyle(color: Colors.grey),
                suffixText: suffix,
                suffixStyle: const TextStyle(color: AppColors.buttonColors),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.buttonColors),
      ),
      child: Row(
        children: [
          const Icon(Icons.wc, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                _buildGenderButton('Male'),
                const SizedBox(width: 16),
                _buildGenderButton('Female'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String genderOption) {
    bool isSelected = gender == genderOption;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => gender = genderOption),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.buttonColors : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.buttonColors),
          ),
          elevation: 0,
        ),
        child: Text(
          genderOption,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.buttonColors,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}