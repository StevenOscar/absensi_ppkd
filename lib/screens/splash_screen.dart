import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/constants/assets_images.dart';
import 'package:absensi_ppkd/helper/shared_pref_helper.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/screens/auth/login_screen.dart';
import 'package:absensi_ppkd/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static String id = "/";
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToPage();
  }

  Future<void> goToPage() async {
    Future.delayed(Duration(milliseconds: 2000), () async {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      } else {
        await ref.read(userProvider.notifier).getUserProfile(context: context);
        Navigator.pushReplacementNamed(context, MainScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(48),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(AssetsImages.imagesLogoTextBottom),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
