import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.signal_wifi_off,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your internet connection\nand try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}