import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:absensi_ppkd/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.mainGrey,
      body: Stack(
        children: [
          Positioned(
            bottom: -((currentWidth)),
            left: -((currentWidth / 2)),
            child: CircleAvatar(backgroundColor: AppColors.mainLemon, radius: currentWidth),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Welcome Back",
                      style: AppTextStyles.heading2(
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainWhite,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Login to your account",
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainWhite,
                      ),
                    ),
                    SizedBox(height: 60),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.mainWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildLabel("Username"),
                          SizedBox(height: 12),
                          TextFormFieldWidget(),
                          SizedBox(height: 12),
                          buildLabel("Password"),
                          SizedBox(height: 12),
                          TextFormFieldWidget(),
                          SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButtonWidget(radius: 10, text: "Login"),
                          ),
                          SizedBox(height: 28),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: AppTextStyles.body3(
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.mainBlack,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: AppTextStyles.body3(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.mainLightBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.body2(fontWeight: FontWeight.w500, color: AppColors.mainBlack),
    );
  }
}
