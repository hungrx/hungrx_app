import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  _BasicInformationScreenState createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Basic Information', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              // Implement save functionality
              Navigator.of(context).pop();
            },
            child: Text('Done', style: TextStyle(color: AppColors.buttonColors)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputField(Icons.person, 'Name', nameController),
            SizedBox(height: 16),
            _buildGenderSelector(),
            SizedBox(height: 16),
            _buildInputField(Icons.phone, 'Phone number', phoneController),
            SizedBox(height: 16),
            _buildInputField(Icons.email, 'Email', emailController),
            SizedBox(height: 16),
            _buildInputField(Icons.cake, 'Age', ageController),
            SizedBox(height: 16),
            _buildInputField(Icons.monitor_weight, 'Weight', weightController, suffix: 'kg'),
            SizedBox(height: 16),
            _buildInputField(Icons.monitor_weight_outlined, 'Target Weight', targetWeightController, suffix: 'kg'),
            SizedBox(height: 16),
            _buildInputField(Icons.flag, 'Goal pace', goalPaceController, suffix: 'kg'),
            SizedBox(height: 16),
            _buildInputField(Icons.height, 'Height', heightController, suffix: 'cm'),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String label, TextEditingController controller, {String? suffix}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.buttonColors),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                labelStyle: TextStyle(color: Colors.grey),
                suffixText: suffix,
                suffixStyle: TextStyle(color: AppColors.buttonColors),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.buttonColors),
      ),
      child: Row(
        children: [
          Icon(Icons.wc, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                _buildGenderButton('Male'),
                SizedBox(width: 16),
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
        child: Text(
          genderOption,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.buttonColors,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.buttonColors : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.buttonColors),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}