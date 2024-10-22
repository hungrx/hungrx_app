import 'package:flutter/material.dart';

class HeaderTextDataScreen extends StatelessWidget {
  final String data;
  const HeaderTextDataScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
