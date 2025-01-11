import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/userprofile_screens/help_support_screen.dart/feedbacks_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
                  _buildSupportItem(
                    icon: Icons.school_outlined,
                    title: 'Knowledge Base',
                    onTap: () =>
                        _launchUrl('https://hungrx.com/knowledge-base'),
                  ),
                  _buildDivider(),
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
              margin: const EdgeInsets.only(left: 16,right: 16),
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
                  _buildDivider(),
                  _buildSupportItem(
                    icon: Icons.poll_outlined,
                    title: 'Take a quick survey',
                    onTap: () => _launchUrl('https://hungrx.com/survey'),
                  ),
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
class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  ContactUsScreenState createState() => ContactUsScreenState();
}

class ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedIssue = 'General Inquiry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Contact Us', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.mail_outline,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "We're here to help",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildDropdown(),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Please describe your issue',
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColors,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Issue:', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedIssue,
              isExpanded: true,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              items: [
                'General Inquiry',
                'Technical Support',
                'Billing Issue',
                'Feature Request',
                'Bug Report',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _selectedIssue = newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Implement form submission logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for contacting us!')),
      );
      Navigator.pop(context);
    }
  }
}
