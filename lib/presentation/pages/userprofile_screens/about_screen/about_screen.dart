import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class PoliciesScreen extends StatefulWidget {
  const PoliciesScreen({super.key});

  @override
  State<PoliciesScreen> createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends State<PoliciesScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> launchUrlInBrowser(
      BuildContext context, String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Could not launch the webpage. Please try again later.'),
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
                'Version $_version',
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
              onTap: () => launchUrlInBrowser(
                  context, 'https://www.hungrx.com/terms-and-conditions.html'),
            ),
            _buildPolicyItem(
              context,
              icon: Icons.security_outlined,
              title: 'Privacy Policy',
              onTap: () => launchUrlInBrowser(
                  context, 'https://www.hungrx.com/privacy-policy.html'),
            ),
            _buildPolicyItem(
              context,
              icon: Icons.cookie_outlined,
              title: 'Cookie Policy',
              onTap: () => launchUrlInBrowser(
                  context, 'https://www.hungrx.com/cookie-policy.html'),
            ),
            // Add this right after the Cookie Policy list tile and before the About list tile
            _buildPolicyItem(
              context,
              icon:
                  Icons.medical_information_outlined, // Using medical info icon
              title: 'References & Citations',
              onTap: () => launchUrlInBrowser(context,
                  'https://www.hungrx.com/citations.html'),
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
                'Version $_version',
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
