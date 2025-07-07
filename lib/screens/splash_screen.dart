import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/constants/assets_images.dart';
import 'package:absensi_ppkd/screens/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String id = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    changePage();
  }

  Future<void> changePage() async {
    Future.delayed(Duration(milliseconds: 2500), () async {
      Navigator.pushReplacementNamed(context, MainScreen.id);
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
              child: Image.asset(AssetsImages.imagesLogoWithText),
            ),
          ],
        ),
      ),
    );
  }
}
