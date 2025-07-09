import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    double currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      body: Stack(
        children: [
          Positioned(
            top: -(currentWidth),
            left: -(currentWidth / 2),
            child: CircleAvatar(backgroundColor: AppColors.mainLightBlue, radius: currentWidth),
          ),
          Positioned(
            top: currentWidth * 0.35,
            left: -(currentWidth / 3 - currentWidth / 6),
            child: CircleAvatar(backgroundColor: AppColors.mainGrey, radius: currentWidth * 0.75),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 70),
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
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mainWhite,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        buildListTile(icon: Icon(Icons.edit_outlined), title: Text("Edit Profile")),
                        buildListTile(icon: Icon(Icons.security), title: Text("Change Password")),
                        buildListTile(icon: Icon(Icons.logout_outlined), title: Text("Log Out")),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListTile buildListTile({required Icon icon, required Text title}) {
    return ListTile(leading: icon, title: title);
  }
}
