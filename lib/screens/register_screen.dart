import 'dart:convert';
import 'dart:io';

import 'package:absensi_ppkd/api/training_api.dart';
import 'package:absensi_ppkd/api/user_api.dart';
import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/models/batch_model.dart';
import 'package:absensi_ppkd/models/response_model.dart';
import 'package:absensi_ppkd/models/training_model.dart';
import 'package:absensi_ppkd/screens/login_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
import 'package:absensi_ppkd/widgets/dropdown_form_field_widget.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:absensi_ppkd/widgets/text_form_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "/register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late Future<ResponseModel<List<Batch>>> batchFuture;
  late Future<ResponseModel<List<Training>>> trainingFuture;
  List<Batch> batchList = [];
  List<Training> trainingList = [];
  bool isUsernameValid = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool _obscureText = true;
  bool isFormValid = false;
  String? usernameError;
  String? emailError;
  String? passwordError;
  final FToast fToast = FToast();
  bool _isLoading = false;
  final ImagePicker picker = ImagePicker();
  String genderValue = "L";
  File? selectedImage;
  String? selectedBatch;
  String? selectedTraining;

  @override
  void initState() {
    fToast.init(context);
    super.initState();
    batchFuture = TrainingApi.getAllBatches();
    trainingFuture = TrainingApi.getAllTraining();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void checkValidity() {
    setState(() {
      isFormValid =
          isUsernameValid &&
          isEmailValid &&
          isPasswordValid &&
          (selectedBatch != null) &&
          (selectedTraining != null);
    });
  }

  Future<void> register() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final batchId = batchList.firstWhere((element) => element.batchKe == selectedBatch).id;
      final trainingId = trainingList.firstWhere((element) => element.title == selectedTraining).id;
      final res = await UserApi.createUser(
        username: usernameController.text,
        password: passwordController.text,
        email: emailController.text,
        gender: genderValue,
        profilePhoto: selectedImage == null ? null : base64Encode(selectedImage!.readAsBytesSync()),
        batchId: batchId,
        trainingId: trainingId,
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

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.mainGrey,
      body: RefreshIndicator(
        onRefresh: () async {
          batchFuture = TrainingApi.getAllBatches();
          trainingFuture = TrainingApi.getAllTraining();
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Positioned(
                    bottom: -(currentWidth - 200),
                    left: -(currentWidth / 2),
                    child: CircleAvatar(backgroundColor: AppColors.mainLemon, radius: currentWidth),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60),
                      Text(
                        "Register",
                        style: AppTextStyles.heading2(
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainWhite,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Register your account",
                        style: AppTextStyles.body2(
                          fontWeight: FontWeight.w500,
                          color: AppColors.mainWhite,
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.mainWhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  pickImage();
                                },
                                child: CircleAvatar(
                                  backgroundColor: AppColors.mainGrey.withValues(alpha: 0.9),
                                  radius: 80,
                                  child:
                                      selectedImage == null
                                          ? Icon(
                                            Icons.camera_alt_outlined,
                                            size: 70,
                                            color: AppColors.mainWhite,
                                          )
                                          : Image.file(selectedImage!),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            buildLabel("Username"),
                            SizedBox(height: 12),
                            TextFormFieldWidget(
                              maxlines: 1,
                              errorText: usernameError,
                              controller: usernameController,
                              hintText: "Username",
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    isUsernameValid = false;
                                    usernameError = "Username can't be empty";
                                  } else {
                                    isUsernameValid = true;
                                    usernameError = null;
                                  }
                                  checkValidity();
                                });
                              },
                              prefixIcon: Icon(Icons.person_outline, size: 24),
                            ),
                            SizedBox(height: 20),
                            buildLabel("Email"),
                            SizedBox(height: 12),
                            TextFormFieldWidget(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
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
                                  } else if (value.length < 8) {
                                    isPasswordValid = false;
                                    passwordError = "Password can't be shorter than 8 characters";
                                  } else if (!RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d\W]).{8,}$',
                                  ).hasMatch(value)) {
                                    isPasswordValid = false;
                                    passwordError =
                                        "Password must contain uppercase, lowercase, number/symbol";
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
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                      fillColor: WidgetStatePropertyAll(AppColors.mainBlack),
                                      groupValue: genderValue,
                                      value: "L",
                                      title: Text(
                                        "Male",
                                        style: AppTextStyles.body2(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.mainBlack,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          genderValue = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                      fillColor: WidgetStatePropertyAll(AppColors.mainBlack),
                                      groupValue: genderValue,
                                      value: "P",
                                      title: Text(
                                        "Female",
                                        style: AppTextStyles.body2(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.mainBlack,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          genderValue = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            buildLabel("Batch"),
                            SizedBox(height: 12),
                            FutureBuilder<ResponseModel<List<Batch>>>(
                              future: batchFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text("Error: ${snapshot.error}"));
                                } else if (snapshot.hasData && snapshot.data!.data != null) {
                                  batchList = snapshot.data!.data!;
                                  return DropdownSearchWidget<String>(
                                    value: selectedBatch,
                                    prefixIcon: Icon(Icons.group_outlined),
                                    title: "Select Batch",
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select an option';
                                      }
                                      return null;
                                    },
                                    dropdownItemList: batchList.map((e) => e.batchKe).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBatch = value!;
                                        checkValidity();
                                      });
                                    },
                                  );
                                } else {
                                  AppToast.showErrorToast(
                                    fToast,
                                    snapshot.data?.message ?? "Error",
                                  );
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.category, size: 80),
                                          SizedBox(height: 12),
                                          Text(
                                            "No Batch Available",
                                            style: AppTextStyles.body2(fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            buildLabel("Training Program"),
                            SizedBox(height: 12),
                            FutureBuilder<ResponseModel<List<Training>>>(
                              future: trainingFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text("Error: ${snapshot.error}"));
                                } else if (snapshot.hasData && snapshot.data!.data != null) {
                                  trainingList = snapshot.data!.data!;
                                  return DropdownSearchWidget<String>(
                                    prefixIcon: Icon(Icons.school_outlined),
                                    title: "Select Training",
                                    value: selectedTraining,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select an option';
                                      }
                                      return null;
                                    },
                                    dropdownItemList: trainingList.map((e) => e.title).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedTraining = value!;
                                        checkValidity();
                                      });
                                    },
                                  );
                                } else {
                                  AppToast.showErrorToast(
                                    fToast,
                                    snapshot.data?.message ?? "Error",
                                  );
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.category, size: 80),
                                          SizedBox(height: 12),
                                          Text(
                                            "No Training Available",
                                            style: AppTextStyles.body2(fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 36),
                            _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButtonWidget(
                                    radius: 10,
                                    text: "Register",
                                    elevation: 4,
                                    onPressed:
                                        isFormValid
                                            ? () {
                                              register();
                                            }
                                            : null,
                                    verticalPadding: 16,
                                  ),
                                ),
                            SizedBox(height: 28),
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  text: "Already have an account? Please ",
                                  style: AppTextStyles.body3(
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.mainBlack,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Sign In",
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pop(context);
                                            },
                                      style: AppTextStyles.body3(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.mainLightBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
