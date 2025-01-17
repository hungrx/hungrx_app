import 'dart:math';

import 'package:flutter/material.dart';

class WeightTrackingShimmer extends StatefulWidget {
  const WeightTrackingShimmer({super.key});

  @override
  State<WeightTrackingShimmer> createState() => _WeightTrackingShimmerState();
}

class _WeightTrackingShimmerState extends State<WeightTrackingShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGraphShimmer(),
          const SizedBox(height: 24),
          _buildWeightEntriesShimmer(),
        ],
      ),
    );
  }

  Widget _buildGraphShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerBox(height: 24, width: 150), // Current Weight text
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return CustomPaint(
                  painter: GraphShimmerPainter(
                    animation: _shimmerController.value,
                  ),
                  size: const Size.fromHeight(180),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightEntriesShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildShimmerBox(height: 24, width: 120), // "Weight Entry" text
        ),
        const SizedBox(height: 16),
        ...List.generate(
          4,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(height: 16, width: 100), // Date
                    const SizedBox(height: 4),
                    _buildShimmerBox(height: 12, width: 150), // Weight change text
                  ],
                ),
                _buildShimmerBox(height: 24, width: 70), // Weight value
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerBox({
    required double height,
    required double width,
  }) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[800]!,
                Colors.grey[600]!,
                Colors.grey[800]!,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (_shimmerController.value * 3), 0.0),
              end: Alignment(1.0 + (_shimmerController.value * 3), 0.0),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}

class GraphShimmerPainter extends CustomPainter {
  final double animation;

  GraphShimmerPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    paint.color = Colors.grey[800]!;
    for (var i = 0; i < 5; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw shimmer line
    final Path path = Path();
    path.moveTo(0, size.height * 0.5);
    
    for (var i = 0; i < size.width; i += 30) {
      path.lineTo(
        i.toDouble(),
        size.height * 0.5 + sin((i / 30 + animation) * 3.14) * 20,
      );
    }

    final gradient = LinearGradient(
      colors: [
        Colors.grey[800]!,
        Colors.grey[600]!,
        Colors.grey[800]!,
      ],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment(-1.0 + (animation * 3), 0.0),
      end: Alignment(1.0 + (animation * 3), 0.0),
    );

    paint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(GraphShimmerPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}