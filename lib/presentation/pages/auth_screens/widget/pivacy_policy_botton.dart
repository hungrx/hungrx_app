import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickableTermsAndPolicyText extends StatelessWidget {
  final String termsUrl;
  final String policyUrl;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;

  const ClickableTermsAndPolicyText({
    super.key,
    required this.termsUrl,
    required this.policyUrl,
    this.textStyle,
    this.linkStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textStyle ?? TextStyle(color: Colors.grey[400], fontSize: 12),
        children: [
          const TextSpan(text: "By signing in, I accept the "),
          _buildClickableSpan("Terms of Service", termsUrl),
          const TextSpan(text: " and "),
          _buildClickableSpan("Privacy Policy", policyUrl),
          const TextSpan(text: ", including usage of Cookies"),
        ],
      ),
    );
  }

TextSpan _buildClickableSpan(String text, String url) {
  return TextSpan(
    text: text,
    style: linkStyle ?? 
      const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
    recognizer: TapGestureRecognizer()
      ..onTap = () async {
        final uri = Uri.parse(url);
        try {
          // Changed to universalLaunchUrl for better iOS support
          if (await canLaunchUrl(uri)) {
            final success = await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
          if (!success) {
            debugPrint('Could not launch $url');
          }
          }
        } catch (e) {
          debugPrint("Error launching URL: $e");
        }
      },
  );
}
}
