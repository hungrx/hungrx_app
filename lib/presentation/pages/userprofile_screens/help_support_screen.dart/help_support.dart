import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/help_support_screen.dart/widgets/contact_us_screen.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/help_support_screen.dart/widgets/feedbacks_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchUrl(String url) async {
    try {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const FeedbackDialog(),
    );
  }

  final String inviteText =
      "Block Shorts, Apps, & Notifications to Regain your Focus. Join me now: https://regainapp.ai/download";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Community & Support Header
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Community & Support',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Social Media Icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSocialButton(LucideIcons.instagram,
                      () => _launchUrl('https://www.instagram.com/hungr__x/')),
                  _buildSocialButton(
                      LucideIcons.linkedin,
                      () => _launchUrl(
                          'https://www.linkedin.com/company/hungrx/posts/?feedView=all')),
                  _buildSocialButton(LucideIcons.twitter,
                      () => _launchUrl('https://x.com/hungr_x')),
                ],
              ),
            ),

            // const SizedBox(height: 10),

            // Support Options
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSupportItem(
                    icon: Icons.lightbulb_outline,
                    title: 'Tutorials',
                    onTap: () => _launchUrl('https://hungrx.com/tutorials'),
                  ),
                  _buildDivider(),
                  // _buildSupportItem(
                  //   icon: Icons.school_outlined,
                  //   title: 'Knowledge Base',
                  //   onTap: () =>
                  //       _launchUrl('https://hungrx.com/knowledge-base'),
                  // ),
                  // _buildDivider(),
                  _buildSupportItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Contact Us',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactUsScreen()),
                    ),
                  ),
                ],
              ),
            ),

            // Additional Support Options
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSupportItem(
                    icon: Icons.message_outlined,
                    title: 'Send Feedback',
                    onTap: () => _showFeedbackDialog(context),
                  ),
                  _buildDivider(),
                  _buildSupportItem(
                    icon: Icons.share_outlined,
                    title: 'Share HungrX with a friend',
                    onTap: () {
                      handleShare();
                      // Implement share functionality
                    },
                  ),
                  _buildDivider(),
                  _buildSupportItem(
                    icon: Icons.star_outline,
                    title: 'Rate us on play store',
                    onTap: () => _launchUrl(
                        'https://play.google.com/store/apps/details?id=com.hungrx.app'),
                  ),
                  // _buildDivider(),
                  // _buildSupportItem(
                  //   icon: Icons.poll_outlined,
                  //   title: 'Take a quick survey',
                  //   onTap: () => _launchUrl('https://hungrx.com/survey'),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleShare() async {
    try {
      await Share.share(
        inviteText,
        subject: 'Join Regain App!',
      );
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }

  Widget _buildSocialButton(IconData? icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          fill: 1,
          icon,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildSupportItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[800],
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}

// Contact Us Screen
