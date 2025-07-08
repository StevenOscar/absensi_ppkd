import 'dart:io';

import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:absensi_ppkd/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
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
  final ImagePicker picker = ImagePicker();
  String genderValue = "L";
  File? selectedImage;
  int? batchId;
  int? trainingId;

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
      body: SingleChildScrollView(
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundColor: AppColors.mainGrey,
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
                          SizedBox(height: 16),
                          buildLabel("Username"),
                          SizedBox(height: 12),
                          TextFormFieldWidget(
                            maxlines: 1,
                            controller: usernameController,
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person, size: 24),
                          ),
                          SizedBox(height: 20),
                          buildLabel("Email"),
                          SizedBox(height: 12),
                          TextFormFieldWidget(
                            controller: emailController,
                            hintText: "Email",
                            maxlines: 1,
                            prefixIcon: Icon(Icons.email, size: 24),
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
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                groupValue: genderValue,
                                value: "L",
                                onChanged: (value) {
                                  setState(() {
                                    genderValue = value!;
                                  });
                                },
                              ),
                              Text("Laki-laki"),
                              Radio(
                                groupValue: genderValue,
                                value: "P",
                                onChanged: (value) {
                                  setState(() {
                                    genderValue = value!;
                                  });
                                },
                              ),
                              Text("Perempuan"),
                            ],
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField(
                            decoration: InputDecoration(prefixIcon: Icon(Icons.group_outlined)),
                            isExpanded: true,
                            value: batchId,
                            items: [
                              DropdownMenuItem(value: 1, child: Text("Test 1")),
                              DropdownMenuItem(value: 2, child: Text("Test 2")),
                              DropdownMenuItem(value: 3, child: Text("Test 3")),
                            ],
                            onChanged: (value) {
                              setState(() {
                                batchId = value;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField(
                            decoration: InputDecoration(prefixIcon: Icon(Icons.group_outlined)),
                            isExpanded: true,
                            value: trainingId,
                            items: [
                              DropdownMenuItem(value: 1, child: Text("Test 1")),
                              DropdownMenuItem(value: 2, child: Text("Test 2")),
                              DropdownMenuItem(value: 3, child: Text("Test 3")),
                            ],
                            onChanged: (value) {
                              setState(() {
                                trainingId = value;
                              });
                            },
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
                                text: "Already have an account? Please ",
                                style: AppTextStyles.body3(
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.mainBlack,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign In",
                                    style: AppTextStyles.body3(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.mainLightBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
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
    );
  }
}

Text buildLabel(String text) {
  return Text(
    text,
    style: AppTextStyles.body2(fontWeight: FontWeight.w500, color: AppColors.mainBlack),
  );
}
