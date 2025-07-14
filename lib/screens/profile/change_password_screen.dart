import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/constants/assets_images.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordScreen extends ConsumerWidget {
  static String id = "/change_password";
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.read(userProvider);
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: AppColors.mainGrey,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Reset Password",
            style: AppTextStyles.heading3(fontWeight: FontWeight.w700, color: AppColors.mainWhite),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(60, 20)),
        ),
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: AppColors.mainWhite),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetsImages.imagesResetPassword, width: 150, height: 150),
            SizedBox(height: 8),
            Text(
              "Reset your password",
              style: AppTextStyles.heading2(
                fontWeight: FontWeight.w900,
                color: AppColors.mainBlack,
              ),
            ),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: "An OTP (One-Time Password) will be sent to your registered email address: ",
                style: AppTextStyles.body3(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: userState.user!.email,
                    style: AppTextStyles.body3(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: ". Please press the button below to continue password reset process.",
                    style: AppTextStyles.body3(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButtonWidget(text: "Reset Password", horizontalPadding: 20, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
