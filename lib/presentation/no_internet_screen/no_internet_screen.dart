import 'package:flutter/material.dart';
import 'dart:math' as math;

class NoInternetScreen extends StatefulWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Custom animated WiFi icon
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bounceAnimation.value),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: _buildWifiOffIllustration(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                // Title with gradient
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.red, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Oops! No Internet',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle with custom styling
                Text(
                  'It seems you\'re offline at the moment. Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                // Custom animated button
                _buildRetryButton(),
                const SizedBox(height: 16),
                // Helpful tip
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.lightGreen[200]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.amber[700],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Try turning on mobile data or connecting to Wi-Fi',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWifiOffIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer circle with gradient
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.lightGreen[200]!.withOpacity(0.3),
                Colors.lightGreen[100]!.withOpacity(0.1),
              ],
              radius: 0.8,
            ),
          ),
        ),
        // Inner circle
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // WiFi arcs
                for (int i = 1; i <= 3; i++)
                  Positioned(
                    bottom: 35.0,
                    child: CustomPaint(
                      painter: _WifiArcPainter(
                        radius: 20.0 * i,
                        isActive: false,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                // Wifi icon center dot
                Positioned(
                  bottom: 30.0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Cross line
                Positioned(
                  bottom: 65.0,
                  child: Transform.rotate(
                    angle: -math.pi / 6,
                    child: Container(
                      width: 80,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton(
      onPressed: () {
        // Add a small animation before calling the retry function
        _controller.forward(from: 0).then((_) {
          widget.onRetry();
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
        shadowColor: Colors.green.withOpacity(0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.refresh),
          const SizedBox(width: 8),
          const Text(
            'Try Again',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for WiFi arc
class _WifiArcPainter extends CustomPainter {
  final double radius;
  final bool isActive;
  final double strokeWidth;

  _WifiArcPainter({
    required this.radius,
    required this.isActive,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isActive ? Colors.green : Colors.grey[300]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_WifiArcPainter oldDelegate) =>
      oldDelegate.isActive != isActive || oldDelegate.radius != radius;
}