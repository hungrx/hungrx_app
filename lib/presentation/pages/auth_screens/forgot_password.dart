import 'package:flutter/material.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_button.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/custom_textfield.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/gradient_container.dart';
import 'package:hungrx_app/presentation/pages/auth_screens/widget/header_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        if (_otpSent) {
          setState(() {
            _otpSent = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              if (_otpSent) {
                setState(() {
                  _otpSent = false;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: const Text(
            'Forgot Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
        ),
        body: GradientContainer(
          top: size.height * 0.04, // Reduced top padding to accommodate AppBar
          left: size.height * 0.04,
          right: size.height * 0.04,
          bottom: size.height * 0.04,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                  mainHeading: _otpSent ? "Verify OTP" : "Reset Password",
                  subHeading: _otpSent
                      ? "Enter the OTP sent to your email"
                      : "Enter your email to reset your password",
                ),
                SizedBox(height: size.height * 0.07),
                if (!_otpSent) ...[
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: "Enter your Email id",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    data: "Send OTP",
                    onPressed: () {
                      // Add your OTP sending logic here
                      setState(() {
                        _otpSent = true;
                      });
                    },
                  ),
                ] else ...[
                  CustomTextFormField(
                    controller: _otpController,
                    hintText: "Enter OTP",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _newPasswordController,
                    hintText: "Enter new password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    data: "Confirm",
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Success"),
                            content: const Text("Password reset successfully."),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  // Navigator.of(context).pop();
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const EmailAuthScreen()),
                                  // );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
