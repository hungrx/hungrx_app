import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/core/constants/colors/authscreen_gradient.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        // padding: EdgeInsets.only(top: size.height*0.15,left:size.height*0.05,right: size.height*0.05,bottom: size.height*0.05 ),
        width: double.infinity,
        height: double.infinity,
        decoration: AuthscreenGradient.authGradient,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Welcome back,",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: AppColors.fontColor,
              ),
            ),
            const Text(
              "Glad You’re here",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.fontColor,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                children: [
                  Text("+1"),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter your phone number",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
