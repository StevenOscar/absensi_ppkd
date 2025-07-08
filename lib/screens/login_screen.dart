import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/constants/assets_images.dart';
import 'package:absensi_ppkd/screens/register_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:absensi_ppkd/widgets/text_form_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.mainGrey,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Positioned(
                  bottom: -(currentWidth),
                  left: -(currentWidth / 2),
                  child: CircleAvatar(backgroundColor: AppColors.mainLemon, radius: currentWidth),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(AssetsImages.imagesLogoTextBottom),
                      ),
                    ),
                    SizedBox(height: 16),
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
                          TextFormFieldWidget(
                            maxlines: 1,
                            controller: usernameController,
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person, size: 24),
                          ),
                          SizedBox(height: 20),
                          buildLabel("Password"),
                          SizedBox(height: 12),
                          TextFormFieldWidget(
                            controller: passwordController,
                            hintText: "Password",
                            maxlines: 1,
                            prefixIcon: Icon(Icons.lock, size: 24),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.visibility_outlined, size: 22),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot password?",
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainLightBlue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButtonWidget(
                              radius: 10,
                              text: "Login",
                              elevation: 4,
                              onPressed: () {},
                              verticalPadding: 16,
                            ),
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
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(context, RegisterScreen.id);
                                          },
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
              ],
            ),
          ),
        ),
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
