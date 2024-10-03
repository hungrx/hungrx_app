import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/widgets/responsive_text.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  const HeaderSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
           ResponsiveTextWidget(
            text: title,
            fontWeight: FontWeight.bold,
            sizeFactor: 0.05,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}