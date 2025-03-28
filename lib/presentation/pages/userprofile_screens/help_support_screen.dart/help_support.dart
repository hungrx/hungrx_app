import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/referral/referral_bloc.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/help_support_screen.dart/widgets/contact_us_screen.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/help_support_screen.dart/widgets/feedbacks_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

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

  String getInviteLink() {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id=com.hungrx.hungrx_app";
    } else if (Platform.isIOS) {
      return "https://apps.apple.com/us/app/hungrx/id6741845887";
    }
    return "https://www.hungrx.com/"; // fallback URL
  }

  void _showReferralDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[900],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your Referral Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<ReferralBloc, ReferralState>(
                        builder: (context, state) {
                          if (state is ReferralSuccess) {
                            return Text(
                              state.referralCode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy,
                            color: AppColors.buttonColors),
                        onPressed: () {
                          final state = context.read<ReferralBloc>().state;
                          if (state is ReferralSuccess) {
                            Clipboard.setData(
                                ClipboardData(text: state.referralCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Referral code copied!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share, color: Colors.black),
                  label: const Text(
                    'Invite Friends',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColors,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    final state = context.read<ReferralBloc>().state;
                    if (state is ReferralSuccess) {
                      handleShare(context, state.referralCode);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> handleReferral(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
            ),
          );
        },
      );

      // Trigger referral code generation
      context.read<ReferralBloc>().add(GenerateReferralCode());

      // Wait for the state to change
      await for (final state in context.read<ReferralBloc>().stream) {
        if (state is ReferralSuccess) {
          Navigator.pop(context); // Close loading dialog
          _showReferralDialog(context);
          break;
        } else if (state is ReferralFailure) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
          break;
        }
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Failed to generate referral code. Please try again.')),
      );
      debugPrint('Error handling referral: $e');
    }
  }

  Future<void> handleShare(BuildContext context, String referralCode) async {
    try {
      String baseText =
          "Share HungrX and help your friends discover smarter eating with personalized meal recommendations and nearby restaurant insights!";
      String link = getInviteLink();
      String inviteText =
          "$baseText Use my referral code: $referralCode Join me now: $link";

      await Share.share(
        inviteText,
        subject: 'Join hungrX App!',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share. Please try again.')),
      );
      debugPrint('Error sharing: $e');
    }
  }

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
                  _buildSocialButton(
                      LucideIcons.x, () => _launchUrl('https://x.com/hungr_x')),
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
                    onTap: () => _launchUrl('https://hungrx.com/'),
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
                    onTap: () => handleReferral(context), // Modified this line
                  ),
                  _buildDivider(),
                  _buildSupportItem(
                    icon: Icons.star_outline,
                    title: Platform.isIOS
                        ? 'Rate us on App Store'
                        : 'Rate us on Play Store',
                    onTap: () => _launchUrl(Platform.isIOS
                        ? 'https://apps.apple.com/us/app/hungrx/id6741845887' // Replace with your actual App Store ID
                        : 'https://play.google.com/store/apps/details?id=com.hungrx.hungrx_app'),
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
