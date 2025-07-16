import 'package:absensi_ppkd/api/user_api.dart';
import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/screens/profile/change_password_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
import 'package:absensi_ppkd/utils/copyright_text.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:absensi_ppkd/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';

class EnterEmailScreen extends StatefulWidget {
  static String id = "/enter_email";
  const EnterEmailScreen({super.key});

  @override
  State<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? emailError;
  bool isEmailValid = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void sendOtp() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final res = await UserApi.postRequestOtp(email: _emailController.text);
      if (!mounted) return;
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(context, errorList);
      } else if (res.data != null) {
        AppToast.showSuccessToast(context, res.message);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(email: _emailController.text),
          ),
        );
      } else {
        if (!mounted) return;
        AppToast.showErrorToast(context, res.message);
      }
    } catch (e) {
      if (!mounted) return;
      AppToast.showErrorToast(context, e.toString());
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: AppColors.mainGrey,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Enter Email",
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              "Enter your email address",
              style: AppTextStyles.heading3(
                fontWeight: FontWeight.w700,
                color: AppColors.mainBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We'll send you a one-time password (OTP) to verify your account.",
              style: AppTextStyles.body2(fontWeight: FontWeight.w400, color: AppColors.mainBlack),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: TextFormFieldWidget(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                hintText: "Email",
                filled: true,
                maxlines: 1,
                errorText: emailError,
                onChanged: (value) {
                  setState(() {
                    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                    if (value.isEmpty || !emailRegex.hasMatch(value)) {
                      isEmailValid = false;
                      emailError = "Email is not valid";
                    } else {
                      isEmailValid = true;
                      emailError = null;
                    }
                  });
                },
                prefixIcon: Icon(Icons.email_outlined, size: 24),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButtonWidget(
                    onPressed: isEmailValid ? sendOtp : null,
                    text: "Send OTP",
                  ),
                ),
            CopyrightText.build,
          ],
        ),
      ),
    );
  }
}
