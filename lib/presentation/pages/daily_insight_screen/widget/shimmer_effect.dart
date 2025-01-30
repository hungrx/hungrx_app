import 'package:flutter/material.dart';

class DailyInsightShimmer extends StatelessWidget {
  const DailyInsightShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the entire content in SingleChildScrollView to handle overflow
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalorieProgressShimmer(),
            _buildMealSectionShimmer('Breakfast'),
            _buildMealSectionShimmer('Lunch'),
            _buildMealSectionShimmer('Dinner'),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieProgressShimmer() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        // Calculate responsive sizes based on available width
        final circleSize = constraints.maxWidth * 0.35;
        return Row(
          children: [
            ShimmerBox(
              width: circleSize,
              height: circleSize,
              borderRadius: circleSize / 2,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalorieInfoShimmer(),
                  const SizedBox(height: 16),
                  _buildCalorieInfoShimmer(),
                  const SizedBox(height: 16),
                  _buildCalorieInfoShimmer(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCalorieInfoShimmer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Row(
          children: [
            const ShimmerBox(width: 24, height: 24, borderRadius: 12),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: maxWidth * 0.6, // 60% of available width
                  height: 12,
                  borderRadius: 6,
                ),
                const SizedBox(height: 4),
                ShimmerBox(
                  width: maxWidth * 0.4, // 40% of available width
                  height: 16,
                  borderRadius: 6,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMealSectionShimmer(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 120, height: 24, borderRadius: 6),
          const SizedBox(height: 16),
          _buildMealItemShimmer(),
          const SizedBox(height: 8),
          _buildMealItemShimmer(),
        ],
      ),
    );
  }

  Widget _buildMealItemShimmer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return Row(
            children: [
              const ShimmerBox(width: 40, height: 40, borderRadius: 8),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: maxWidth * 0.4, // 40% of available width
                      height: 16,
                      borderRadius: 6,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ShimmerBox(
                          width: maxWidth * 0.25, // 25% of available width
                          height: 12,
                          borderRadius: 6,
                        ),
                        const SizedBox(width: 8),
                        ShimmerBox(
                          width: maxWidth * 0.2, // 20% of available width
                          height: 12,
                          borderRadius: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ShimmerBox(
                    width: maxWidth * 0.15, // 15% of available width
                    height: 16,
                    borderRadius: 6,
                  ),
                  const SizedBox(height: 4),
                  ShimmerBox(
                    width: maxWidth * 0.2, // 20% of available width
                    height: 12,
                    borderRadius: 6,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  ShimmerBoxState createState() => ShimmerBoxState();
}

class ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(
                _animation.value - 1,
                0,
              ),
              end: Alignment(
                _animation.value + 1,
                0,
              ),
              colors: [
                Colors.grey[900]!,
                Colors.grey[800]!,
                Colors.grey[900]!,
              ],
            ),
          ),
        );
      },
    );
  }
}
