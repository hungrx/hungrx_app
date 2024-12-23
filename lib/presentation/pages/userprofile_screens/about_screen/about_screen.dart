import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

Future<void> launchUrlInBrowser(BuildContext context, String urlString) async {
  try {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // This forces the URL to open in external browser
    )) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch the webpage. Please try again later.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'About HungrX',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'HungrX is your ultimate nutrition and fitness companion. We help you achieve your health goals through personalized meal plans and expert guidance.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                'Version 4.1.0',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: AppColors.buttonColors),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Policies',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPolicyItem(
              context,
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () => launchUrlInBrowser(context,'https://www.hungrx.com/terms-and-conditions.html'),
            ),
            _buildPolicyItem(
              context,
              icon: Icons.security_outlined,
              title: 'Privacy Policy',
              onTap: () => launchUrlInBrowser(context,'https://www.hungrx.com/privacy-policy.html'),
            ),
            // _buildPolicyItem(
            //   context,
            //   icon: Icons.medical_services_outlined,
            //   title: 'Health Disclaimer',
            //   onTap: () => launchUrlInBrowser(context,'https://www.hungrx.com/health-disclaimer.html'),
            // ),
            _buildPolicyItem(
              context,
              icon: Icons.cookie_outlined,
              title: 'Cookie Policy',
              onTap: () => launchUrlInBrowser(context,'https://www.hungrx.com/cookie-policy.html'),
            ),
            _buildPolicyItem(
              context,
              icon: Icons.info_outline,
              title: 'About',
              onTap: () => _showAboutDialog(context),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Version 4.1.0',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}