import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/helper/shared_pref_helper.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/screens/auth/login_screen.dart';
import 'package:absensi_ppkd/screens/profile/edit_profile_screen.dart';
import 'package:absensi_ppkd/screens/profile/request_otp_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/copyright_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    ref.read(userProvider.notifier).getUserProfile(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
                color: AppColors.mainGrey,
              ),
              width: double.infinity,
              padding: EdgeInsets.only(top: 80, bottom: 28, left: 24, right: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: ClipOval(
                      child:
                          userState.user!.profilePhoto == null
                              ? Container(
                                color: AppColors.mainLightBlue.withValues(alpha: 0.9),
                                child: Icon(
                                  Icons.no_photography_outlined,
                                  size: 70,
                                  color: AppColors.mainWhite,
                                ),
                              )
                              : CachedNetworkImage(
                                imageUrl:
                                    "https://appabsensi.mobileprojp.com/public/${userState.user!.profilePhoto!}",
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
                                      color: AppColors.mainRed.withValues(alpha: 0.3),
                                      child: Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          size: 70,
                                          color: AppColors.mainWhite,
                                        ),
                                      ),
                                    ),
                              ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      userState.user!.name,
                      style: AppTextStyles.heading2(
                        fontWeight: FontWeight.w800,
                        color: AppColors.mainWhite,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 12),
                  buildProfileDataRow(
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: userState.user!.email,
                  ),
                  buildProfileDataRow(
                    icon: Icons.school_outlined,
                    label: "Training",
                    value: userState.user!.training!.title,
                  ),
                  buildProfileDataRow(
                    icon: Icons.group_outlined,
                    label: "Batch",
                    value: userState.user!.batch!.batchKe.toString(),
                  ),
                  buildProfileDataRow(
                    icon: Icons.person_outline,
                    label: "Gender",
                    value: userState.user!.jenisKelamin! == "L" ? "Male" : "Female",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  buildListTile(
                    icon: Icon(Icons.edit_outlined, size: 30, color: AppColors.mainLightBlue),
                    title: Text(
                      "Edit Profile",
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainBlack,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, EditProfileScreen.id);
                    },
                  ),
                  buildListTile(
                    icon: Icon(Icons.security_outlined, size: 30, color: AppColors.mainLightBlue),
                    title: Text(
                      "Change Password",
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainBlack,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RequestOtpScreen.id);
                    },
                  ),
                  buildListTile(
                    icon: Icon(Icons.logout_outlined, size: 30, color: AppColors.mainRed),
                    title: Text(
                      "Log Out",
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainRed,
                      ),
                    ),
                    onTap: () async {
                      await SharedPrefHelper.deleteToken();
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                  CopyrightText.build,
                  SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileDataRow({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
    Color? labelColor,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? AppColors.blue, size: 22),
          SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: AppTextStyles.body2(
                fontWeight: FontWeight.w600,
                color: labelColor ?? AppColors.mainWhite,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: AppTextStyles.body2(
                fontWeight: FontWeight.w400,
                color: valueColor ?? AppColors.mainWhite,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildListTile({
    required Icon icon,
    required Text title,
    required Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            leading: icon,
            title: Padding(padding: const EdgeInsets.only(left: 4), child: title),
          ),
          Divider(),
        ],
      ),
    );
  }
}
