import 'package:hungrx_app/presentation/pages/onboarding_screen/components/onboarding_info.dart';

class OnboardingData {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        description:
            "Discover nearby restaurants within your calorie budget",
        image: "assets/images/onboard1.jpeg"),
    OnboardingInfo(
        description: "Get menu suggestions tailored to your daily calorie target.",
        image: "assets/images/onboard2.jpeg"),
    OnboardingInfo(
        description: "Track your intake, stick to your calorie goals, and achieve results.",
        image: "assets/images/onboard3.jpeg"),
  ];
}
