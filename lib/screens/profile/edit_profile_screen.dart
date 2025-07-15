import 'dart:io';

import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
import 'package:absensi_ppkd/widgets/dropdown_form_field_widget.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:absensi_ppkd/widgets/text_form_field_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static String id = '/edit_profile';
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isUsernameValid = true;
  bool isEmailValid = true;
  bool _isLoading = false;
  bool isFormValid = true;
  String? usernameError;
  String? emailError;
  String genderValue = "L";
  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  String? currentImage;
  String? selectedBatch;
  String? selectedTraining;

  Future<void> update() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    final updateProfile = await ref
        .read(userProvider.notifier)
        .updateUserProfile(context: context, username: usernameController.text);
    if (selectedImage != null) {
      final updatePhoto = await ref
          .read(userProvider.notifier)
          .updateUserPicture(context: context, image: selectedImage!);
      if (updateProfile && updatePhoto) {
        if (!mounted) return;
        AppToast.showSuccessToast(context, "Update Profile Success");
        await ref.read(userProvider.notifier).getUserProfile(context: context);
        Navigator.pop(context);
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }
    if (updateProfile) {
      if (!mounted) return;
      AppToast.showSuccessToast(context, "Update Profile Success");
      await ref.read(userProvider.notifier).getUserProfile(context: context);
      Navigator.pop(context);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  void _checkValidity() {
    setState(() {
      isFormValid =
          isUsernameValid && isEmailValid && (selectedBatch != null) && (selectedTraining != null);
    });
  }

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
    }
    setState(() {});
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final userState = ref.read(userProvider);
    super.initState();
    usernameController.text = userState.user!.name;
    emailController.text = userState.user!.email;
    currentImage = userState.user!.profilePhoto;
    selectedTraining = userState.user!.training?.title;
    selectedBatch = userState.user!.batch?.batchKe;
    genderValue = userState.user!.jenisKelamin ?? "L";
  }

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainLightBlue,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: AppColors.mainGrey,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            "Edit Profile",
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
                Positioned(
                  top: -(currentWidth - 120),
                  left: -(currentWidth / 2),
                  child: CircleAvatar(
                    backgroundColor: AppColors.mainLightBlue,
                    radius: currentWidth,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: ClipOval(
                          child:
                              selectedImage != null
                                  ? Image.file(selectedImage!, fit: BoxFit.cover)
                                  : (currentImage != null
                                      ? CachedNetworkImage(
                                        imageUrl:
                                            "https://appabsensi.mobileprojp.com/public/$currentImage",
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Container(
                                              color: AppColors.mainGrey.withValues(alpha: 0.3),
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  color: AppColors.mainWhite,
                                                ),
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => Container(
                                              color: AppColors.mainGrey.withValues(alpha: 0.3),
                                              child: Center(
                                                child: Icon(
                                                  Icons.no_photography_outlined,
                                                  size: 70,
                                                  color: AppColors.mainWhite,
                                                ),
                                              ),
                                            ),
                                      )
                                      : Container(
                                        color: AppColors.mainGrey.withValues(alpha: 0.9),
                                        child: Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 70,
                                            color: AppColors.mainWhite,
                                          ),
                                        ),
                                      )),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: AppColors.mainWhite,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 28),
                      child: Column(
                        children: [
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
                                _checkValidity();
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
                            enabled: false,
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
                                _checkValidity();
                              });
                            },
                            prefixIcon: Icon(Icons.email_outlined, size: 24),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  fillColor: WidgetStatePropertyAll(Colors.grey),
                                  groupValue: genderValue,
                                  value: "L",
                                  title: Text(
                                    "Male",
                                    style: AppTextStyles.body2(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onChanged: null,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  fillColor: WidgetStatePropertyAll(Colors.grey),
                                  groupValue: genderValue,
                                  value: "P",
                                  title: Text(
                                    "Female",
                                    style: AppTextStyles.body2(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onChanged: null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          DropdownSearchWidget<String>(
                            value: selectedBatch,
                            dropdownItemList: [selectedBatch!],
                            onChanged: null,
                            enabled: false,
                            title: "Select Batch",
                            prefixIcon: Icon(Icons.group_outlined),
                          ),
                          SizedBox(height: 16),
                          DropdownSearchWidget<String>(
                            value: selectedTraining,
                            enabled: false,
                            dropdownItemList: [selectedTraining ?? "0"],
                            onChanged: null,
                            title: "Select Training",
                            prefixIcon: Icon(Icons.school_outlined),
                          ),
                          SizedBox(height: 40),
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : SizedBox(
                                width: double.infinity,
                                child: ElevatedButtonWidget(
                                  radius: 10,
                                  text: "Edit",
                                  elevation: 4,
                                  onPressed:
                                      isFormValid
                                          ? () {
                                            update();
                                          }
                                          : null,
                                  verticalPadding: 16,
                                ),
                              ),
                          SizedBox(height: 8),
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
