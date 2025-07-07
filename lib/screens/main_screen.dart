import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/screens/dashboard_screen.dart';
import 'package:absensi_ppkd/screens/history_screen.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String id = "/main";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screenList = [
    DashboardScreen(),
    DashboardScreen(),
    HistoryScreen(),
    DashboardScreen(),
  ];
  static List<IconData> iconList = [Icons.home, Icons.person, Icons.list_alt, Icons.groups_2];
  static List<String> labelList = ["Home", "Profile", "History", "Users"];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        height: 70,
        gapLocation: GapLocation.center,
        backgroundColor: AppColors.mainWhite,
        tabBuilder: (int index, bool isActive) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Column(
              children: [
                Icon(
                  iconList[index],
                  size: isActive ? 28 : 24,
                  color: isActive ? AppColors.mainGrey : Colors.grey,
                ),
                Text(
                  labelList[index],
                  style: AppTextStyles.body3(
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.mainGrey : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
        activeIndex: currentPage,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 24,
        rightCornerRadius: 24,
        borderColor: AppColors.mainBlack,
        borderWidth: 1,
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          shape: CircleBorder(side: BorderSide.none),
          backgroundColor: AppColors.mainLightBlue,
          onPressed: () {},
          child: Icon(Icons.fingerprint, color: AppColors.mainWhite, size: 48),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screenList[currentPage],
    );
  }
}
