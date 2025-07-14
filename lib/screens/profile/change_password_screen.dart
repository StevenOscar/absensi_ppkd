import 'package:absensi_ppkd/api/user_api.dart';
import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/constants/assets_images.dart';
import 'package:absensi_ppkd/screens/auth/login_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:absensi_ppkd/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String id = "/change_password";
  final String email;
  const ChangePasswordScreen({super.key, required this.email});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationController = TextEditingController();
  late final FToast fToast = FToast();
  String otpValue = "";
  String? passwordError;
  String? confirmationError;
  bool isFormValid = false;
  bool isPasswordValid = false;
  bool isConfirmationValid = false;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmationController.dispose();
  }

  void _checkValidity() {
    isFormValid = otpValue.length == 6 && isPasswordValid && isConfirmationValid;
  }

  Future<void> changePassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final res = await UserApi.postResetPassword(
        email: widget.email,
        password: passwordController.text,
        otp: otpValue,
      );
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(fToast, errorList);
      } else if (res.data != null) {
        AppToast.showSuccessToast(fToast, res.message);
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
      } else {
        AppToast.showErrorToast(fToast, res.message);
      }
    } catch (e) {
      AppToast.showErrorToast(fToast, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Image.asset(AssetsImages.imagesOtp, height: 150),
              SizedBox(height: 8),
              Text(
                "A verification code has been sent to your email address:",
                style: AppTextStyles.body2(fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(widget.email, style: AppTextStyles.body1(fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              Text(
                "Enter 6-digit verification code",
                style: AppTextStyles.body3(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              OtpTextField(
                numberOfFields: 6,
                borderColor: AppColors.mainLightBlue,
                showFieldAsBox: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                borderRadius: BorderRadius.circular(5),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onCodeChanged: (String code) {
                  setState(() {
                    otpValue = code;
                    _checkValidity();
                  });
                },
                onSubmit: (String verificationCode) {
                  setState(() {
                    otpValue = verificationCode;
                    _checkValidity();
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                "Enter your new password",
                style: AppTextStyles.body3(fontWeight: FontWeight.w600),
              ),
              TextFormFieldWidget(
                controller: passwordController,
                hintText: "Password",
                filled: false,
                errorText: passwordError,
                obscureText: _obscurePassword,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      isPasswordValid = false;
                      passwordError = "Password can't be empty";
                    } else if (value.length < 8) {
                      isPasswordValid = false;
                      passwordError = "Password must be at least 8 characters";
                    } else if (!(RegExp(r'[A-Z]').hasMatch(value) &&
                        RegExp(r'[a-z]').hasMatch(value) &&
                        RegExp(r'\d').hasMatch(value) &&
                        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value))) {
                      isPasswordValid = false;
                      passwordError = "Password must include uppercase, lowercase, and symbol";
                    } else {
                      isPasswordValid = true;
                      passwordError = null;
                    }
                    _checkValidity();
                  });
                },
                maxlines: 1,
                prefixIcon: Icon(Icons.lock_outline, size: 24),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 22,
                    ),
                  ),
                ),
              ),
              TextFormFieldWidget(
                controller: confirmationController,
                hintText: "Confirm Password",
                errorText: confirmationError,
                filled: false,
                obscureText: _obscureConfirmation,
                onChanged: (value) {
                  setState(() {
                    if (value != passwordController.text) {
                      isConfirmationValid = false;
                      confirmationError = "Passwords do not match";
                    } else {
                      isConfirmationValid = true;
                      confirmationError = null;
                    }
                    _checkValidity();
                  });
                },
                maxlines: 1,
                prefixIcon: Icon(Icons.lock_outline, size: 24),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmation = !_obscureConfirmation;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmation
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                  : ElevatedButtonWidget(
                    text: "Change Password",
                    horizontalPadding: 20,
                    onPressed:
                        isFormValid
                            ? () async {
                              await changePassword();
                            }
                            : null,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
