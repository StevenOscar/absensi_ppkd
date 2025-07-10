import 'package:absensi_ppkd/api/user_api.dart';
import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/constants/assets_images.dart';
import 'package:absensi_ppkd/helper/shared_pref_helper.dart';
import 'package:absensi_ppkd/models/user_model.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/screens/main_screen.dart';
import 'package:absensi_ppkd/screens/auth/register_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:absensi_ppkd/widgets/text_form_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String id = "/login";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isEmailValid = false;
  bool isPasswordValid = false;
  String? emailError;
  String? passwordError;
  final FToast fToast = FToast();
  bool _isLoading = false;
  bool _obscureText = true;
  bool isFormValid = false;

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void checkValidity() {
    setState(() {
      isFormValid = isEmailValid && isPasswordValid;
    });
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userState = ref.read(userProvider.notifier);
      final res = await UserApi.loginUser(
        email: emailController.text,
        password: passwordController.text,
      );
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(fToast, errorList);
      } else if (res.data != null) {
        await SharedPrefHelper.setToken(res.data!.token);
        await userState.setUser(
          user: User(
            name: res.data!.user.name,
            email: res.data!.user.email,
            jenisKelamin: res.data!.user.jenisKelamin,
            profilePhoto: res.data!.user.profilePhoto,
            updatedAt: res.data!.user.updatedAt,
            createdAt: res.data!.user.createdAt,
            id: res.data!.user.id,
            batch: res.data!.user.batch,
            training: res.data!.user.training,
          ),
        );
        AppToast.showSuccessToast(fToast, res.message);
        Navigator.pushNamedAndRemoveUntil(context, MainScreen.id, (route) => false);
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
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            hintText: "Email",
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
                                checkValidity();
                              });
                            },
                            prefixIcon: Icon(Icons.email_outlined, size: 24),
                          ),
                          SizedBox(height: 20),
                          buildLabel("Password"),
                          SizedBox(height: 12),
                          TextFormFieldWidget(
                            controller: passwordController,
                            hintText: "Password",
                            errorText: passwordError,
                            obscureText: _obscureText,
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  isPasswordValid = false;
                                  passwordError = "Password can't be empty";
                                } else {
                                  isPasswordValid = true;
                                  passwordError = null;
                                }
                                checkValidity();
                              });
                            },
                            maxlines: 1,
                            prefixIcon: Icon(Icons.lock_outline, size: 24),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot password?",
                                style: AppTextStyles.body3(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainLightBlue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : SizedBox(
                                width: double.infinity,
                                child: ElevatedButtonWidget(
                                  radius: 10,
                                  text: "Login",
                                  elevation: 4,
                                  onPressed:
                                      isFormValid
                                          ? () {
                                            login();
                                          }
                                          : null,
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

  Padding buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: AppTextStyles.body2(fontWeight: FontWeight.w500, color: AppColors.mainBlack),
      ),
    );
  }
}
