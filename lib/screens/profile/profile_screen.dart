import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/screens/auth/login_screen.dart';
import 'package:absensi_ppkd/screens/profile/edit_profile_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final FToast fToast = FToast();

  @override
  void initState() {
    fToast.init(context);
    ref.read(userProvider.notifier).getUserProfile(fToast: fToast);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
            padding: EdgeInsets.only(top: 80, bottom: 40),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor:
                      userState.user!.profilePhoto == null
                          ? AppColors.mainGrey.withValues(alpha:0.9)
                          : Colors.transparent,
                  backgroundImage:
                      userState.user!.profilePhoto != null
                          ? NetworkImage(
                            "https://appabsensi.mobileprojp.com/public/${userState.user!.profilePhoto!}",
                          )
                          : null,
                  child:
                      userState.user!.profilePhoto == null
                          ? Icon(Icons.camera_alt_outlined, size: 70, color: AppColors.mainWhite)
                          : null,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    userState.user!.email,
                    style: AppTextStyles.body2(
                      fontWeight: FontWeight.w400,
                      color: AppColors.mainWhite,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                    Navigator.pushNamed(context, EditProfileScreen.id);
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
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
              ],
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
