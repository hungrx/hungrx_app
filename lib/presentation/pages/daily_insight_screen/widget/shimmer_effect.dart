import 'package:flutter/material.dart';

class DailyInsightShimmer extends StatelessWidget {
  const DailyInsightShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCalorieProgressShimmer(),
        _buildMealSectionShimmer('Breakfast'),
        _buildMealSectionShimmer('Lunch'),
      ],
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
      child: Row(
        children: [
          const ShimmerBox(width: 160, height: 160, borderRadius: 80),
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
      ),
    );
  }

  Widget _buildCalorieInfoShimmer() {
    return const Row(
      children: [
        ShimmerBox(width: 24, height: 24, borderRadius: 12),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: 80, height: 12, borderRadius: 6),
            SizedBox(height: 4),
            ShimmerBox(width: 60, height: 16, borderRadius: 6),
          ],
        ),
      ],
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
      child: const Row(
        children: [
          ShimmerBox(width: 40, height: 40, borderRadius: 8),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 120, height: 16, borderRadius: 6),
                SizedBox(height: 8),
                Row(
                  children: [
                    ShimmerBox(width: 80, height: 12, borderRadius: 6),
                    SizedBox(width: 8),
                    ShimmerBox(width: 60, height: 12, borderRadius: 6),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ShimmerBox(width: 60, height: 16, borderRadius: 6),
              SizedBox(height: 4),
              ShimmerBox(width: 80, height: 12, borderRadius: 6),
            ],
          ),
        ],
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
