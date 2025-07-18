import 'dart:async';

import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/helper/permission_helper.dart';
import 'package:absensi_ppkd/providers/navigation_provider.dart';
import 'package:absensi_ppkd/screens/check_in_out/check_in_out_screen.dart';
import 'package:absensi_ppkd/screens/dashboard_screen.dart';
import 'package:absensi_ppkd/screens/history/history_screen.dart';
import 'package:absensi_ppkd/screens/leave_permission/leave_permission.dart';
import 'package:absensi_ppkd/screens/profile/profile_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
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
    LeavePermissionScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  static List<IconData> iconList = [
    Icons.home,
    Icons.work_off_outlined,
    Icons.list_alt,
    Icons.person,
  ];
  static List<String> labelList = ["Home", "Leave", "History", "Profile"];

  @override
  void initState() {
    super.initState();
  }

  void _incrementValue() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      if (opacity == 1) {
        final permission = await PermissionHelper.locationPermission();
        if (permission) {
          Navigator.pushNamed(context, CheckInOutScreen.id);
        } else {
          if (!mounted) return;
          AppToast.showErrorToast(context, "Please Enable Location Permission");
        }
        opacity = 0;
      } else if (opacity < 1) {
        opacity = (opacity + 0.2).clamp(0.0, 1.0);
      } else {
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  void _decrementValue() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (opacity > 0.0) {
          opacity = (opacity - 0.25).clamp(0.0, 1.0);
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
        backgroundColor: Color(0xff272b38),
        tabBuilder: (int index, bool isActive) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Column(
              children: [
                Icon(
                  iconList[index],
                  size: isActive ? 28 : 24,
                  color: isActive ? AppColors.mainLightBlue : Colors.grey.shade500,
                ),
                Text(
                  labelList[index],
                  style: AppTextStyles.body3(
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.mainLightBlue : Colors.grey.shade500,
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
              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff272b38)),
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
