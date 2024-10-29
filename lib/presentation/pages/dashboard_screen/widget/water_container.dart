import 'package:flutter/material.dart';

class WaterAnimationPainter extends CustomPainter {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;

  WaterAnimationPainter(
    this.firstValue,
    this.secondValue,
    this.thirdValue,
    this.fourthValue,
  );

 @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xff3B6ABA).withOpacity(.4)
      ..style = PaintingStyle.fill;

    // Create a rounded rectangle path for clipping
    var clipPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(20),
      ));

    // Apply the clip
    canvas.clipPath(clipPath);

    // Draw the wave - Adjusted y-position for higher waves
    var path = Path()
      ..moveTo(0, size.height * 0.8 / firstValue)  // Adjusted multiplier
      ..cubicTo(
        size.width * .4,
        size.height * 0.7 / secondValue,  // Adjusted multiplier
        size.width * .7,
        size.height * 0.7 / thirdValue,   // Adjusted multiplier
        size.width,
        size.height * 0.8 / fourthValue   // Adjusted multiplier
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WaterContainer extends StatefulWidget {
  final Widget child;
  const WaterContainer({super.key, required this.child});

  @override
  WaterContainerState createState() => WaterContainerState();
}

class WaterContainerState extends State<WaterContainer>
    with TickerProviderStateMixin {
  late AnimationController firstController;
  late Animation<double> firstAnimation;

  late AnimationController secondController;
  late Animation<double> secondAnimation;

  late AnimationController thirdController;
  late Animation<double> thirdAnimation;

  late AnimationController fourthController;
  late Animation<double> fourthAnimation;

  @override
  void initState() {
    super.initState();

    firstController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    firstAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    secondAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });

    thirdController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    thirdAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });

    fourthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    fourthAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });

    firstController.forward();
    secondController.forward();
    thirdController.forward();
    fourthController.forward();
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
 Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: CustomPaint(
              painter: WaterAnimationPainter(
                firstAnimation.value,
                secondAnimation.value,
                thirdAnimation.value,
                fourthAnimation.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}