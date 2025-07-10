import 'dart:async';

import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/navigation_provider.dart';
import 'package:absensi_ppkd/screens/check_in/check_in_screen.dart';
import 'package:absensi_ppkd/screens/dashboard_screen.dart';
import 'package:absensi_ppkd/screens/history/history_screen.dart';
import 'package:absensi_ppkd/screens/profile/profile_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  static const String id = "/main";
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  double opacity = 0;
  Timer? _timer;
  List<Widget> screenList = [
    DashboardScreen(),
    HistoryScreen(),
    DashboardScreen(),
    ProfileScreen(),
  ];
  static List<IconData> iconList = [Icons.home, Icons.list_alt, Icons.groups_2, Icons.person];
  static List<String> labelList = ["Home", "History", "Users", "Profile"];

  void _incrementValue() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (opacity == 1) {
          Navigator.pushNamed(context, CheckInScreen.id);
          opacity = 0;
        } else if (opacity < 1) {
          opacity = (opacity + 0.1).clamp(0.0, 1.0);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _decrementValue() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (opacity > 0.0) {
          opacity = (opacity - 0.2).clamp(0.0, 1.0);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = ref.watch(navigationProvider);
    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        onTap: (value) {
          setState(() {
            ref.read(navigationProvider.notifier).setPage(currentPage: value);
          });
        },
        height: 70,
        notchMargin: 12,
        gapLocation: GapLocation.center,
        backgroundColor: AppColors.mainLemon,
        tabBuilder: (int index, bool isActive) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Column(
              children: [
                Icon(
                  iconList[index],
                  size: isActive ? 28 : 24,
                  color: isActive ? AppColors.mainLightBlue : Colors.grey.shade700,
                ),
                Text(
                  labelList[index],
                  style: AppTextStyles.body3(
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.mainLightBlue : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        },
        activeIndex: navigationState.currentPage,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 24,
        rightCornerRadius: 24,
      ),
      floatingActionButton: GestureDetector(
        onTapDown: (_) {
          _incrementValue();
        },
        onTapUp: (_) {
          _decrementValue();
        },
        onTapCancel: () {
          _decrementValue();
        },
        child: Stack(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.mainGrey),
              child: Icon(Icons.fingerprint, color: AppColors.mainWhite, size: 48),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: opacity,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.mainLightBlue),
                child: Icon(Icons.fingerprint, color: AppColors.mainWhite, size: 48),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screenList[navigationState.currentPage],
    );
  }
}
