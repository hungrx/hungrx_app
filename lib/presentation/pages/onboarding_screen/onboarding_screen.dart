import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/phone_number.dart';
import 'components/onboarding_data.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingData();
  final pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          Expanded(child: body()),
          bottomContainer(),
        ],
      ),
    );
  }

  // Body
  Widget body() {
    return PageView.builder(
      controller: pageController,
      onPageChanged: (value) {
        setState(() {
          currentIndex = value;
        });
      },
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                controller.items[index].image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: -5,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                padding: const EdgeInsets.only(top: 50, right: 30, left: 30),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(60)),
                ),
                child: Text(
                  controller.items[index].description,
                  style: const TextStyle(
                      color: AppColors.fontColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Bottom Container with Dots and Button
  Widget bottomContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          button(),
          const SizedBox(
            width: 20,
          ),
          buildDots(),
        ],
      ),
    );
  }

  // Dots
  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.items.length,
        (index) => AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: currentIndex == index
                ? AppColors.primaryColor
                : AppColors.buttonColors,
          ),
          height: 10,
          width: currentIndex == index ? 30 : 10,
          duration: const Duration(milliseconds: 700),
        ),
      ),
    );
  }

  // Button
  Widget button() {
    return Container(
      width: MediaQuery.of(context).size.width * .4,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.buttonColors,
      ),
      child: TextButton(
        onPressed: () {
          if (currentIndex != controller.items.length - 1) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const PhoneNumberScreen()),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: Text(
          currentIndex == controller.items.length - 1
              ? "Get started"
              : "Continue",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
