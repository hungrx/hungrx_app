import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/basic_information_screen/basic_informaion_screen.dart';
import 'package:hungrx_app/core/widgets/bottom_navbar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _selectedIndex = 2; // Set to 2 for 'Profile' tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
       context.go('/dashboard');
        break;
      case 1:
      context.go('/eatscreen');
        break;
      case 2:
        // Already on UserProfileScreen, no navigation needed
        break;
      case 3:
        context.go('/foodcart');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildUserStats(),
              _buildPersonalDetails(context),
              _buildAppSettings(),
              _buildInviteSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 40.0, bottom: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/dp.png'),
          ),
          SizedBox(height: 10),
          Text(
            'Warren Daniel',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('TDEE', '2315 cal'),
          _buildStatItem('Weight', '100 Kg'),
          _buildStatItem('Goal', '85 Kg'),
          _buildStatItem('BMI', '18.5'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPersonalDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Personal Details',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        _buildDetailItem(
          Icons.info_outline,
          'Basic Information',
          'Height, weight, age, gender...',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BasicInformationScreen()),
            );
          },
        ),
        _buildDetailItem(
            Icons.flag_outlined, 'Primary Goal', 'Gain weight...', () {}),
        _buildDetailItem(
            Icons.pie_chart_outline, 'Statistics', 'Current status...', () {}),
      ],
    );
  }

  Widget _buildAppSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('App Settings',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        _buildDetailItem(Icons.person_outline, 'Account',
            'Change mail, log out, delete account', () {
          context.go('/accountSettings');
        }),
        _buildDetailItem(Icons.info_outline, 'About',
            'About us, Privacy Policy, app version', () {}),
        _buildDetailItem(Icons.help_outline, 'Help & Support',
            'Help, feedbacks, troubleshoot', () {}),
      ],
    );
  }

  Widget _buildDetailItem(
      IconData icon, String title, String subtitle, void Function()? ontap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: ontap, // Implement navigation or action
    );
  }

  Widget _buildInviteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Invite your friends',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 100,
          decoration: BoxDecoration(
            image: const DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/referrel.jpg")),
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: const Icon(Icons.person, color: Colors.blue)),
              CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: const Icon(Icons.share, color: Colors.green)),
              CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  child: const Icon(Icons.person, color: Colors.orange)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.person_add, color: Colors.black),
            label:
                const Text('Refer Now', style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColors,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            onPressed: () {}, // Implement refer functionality
          ),
        ),
      ],
    );
  }
}
