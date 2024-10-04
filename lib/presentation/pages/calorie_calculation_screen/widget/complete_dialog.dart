import 'dart:ui';

import 'package:flutter/material.dart';

class CompletionDialog extends StatefulWidget {
  final String message;
  final VoidCallback onComplete;

  const CompletionDialog({super.key, required this.message, required this.onComplete});

  @override
  _CompletionDialogState createState() => _CompletionDialogState();
}

class _CompletionDialogState extends State<CompletionDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Automatically close dialog and navigate after animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(microseconds: 200), () {
          widget.onComplete();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(100, 100),
                painter: CheckmarkPainter(_animation.value),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CheckmarkPainter extends CustomPainter {
  final double animationValue;

  CheckmarkPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double startX = size.width * 0.2;
    final double endX = size.width * 0.45;
    final double endY = size.height * 0.7;

    final path = Path()
      ..moveTo(startX, size.height * 0.5)
      ..lineTo(endX, endY)
      ..lineTo(size.width * 0.8, size.height * 0.3);

    final PathMetric pathMetric = path.computeMetrics().first;
    final Path extractPath = pathMetric.extractPath(
      0.0,
      pathMetric.length * animationValue,
    );

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) => animationValue != oldDelegate.animationValue;
}