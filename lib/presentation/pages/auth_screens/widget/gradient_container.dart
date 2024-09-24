import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/authscreen_gradient.dart';

class GradientContainer extends StatelessWidget {
  final double top;
  final double left;
  final double right;
  final double bottom;
  final Widget? child;

  const GradientContainer(
      {super.key,
      required this.top,
      required this.left,
      required this.right,
      required this.bottom,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
      ),
      width: double.infinity,
      height: double.infinity,
      decoration: AuthscreenGradient.authGradient,
      child: child,
    );
  }
}
