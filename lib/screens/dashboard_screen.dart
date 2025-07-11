import 'dart:async';

import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/check_in_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const String id = "/dsahboard";
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late String _timeString;

  @override
  void initState() {
    _timeString = DateFormat("HH:mm:ss").format(DateTime.now()).replaceAll(":", " : ");
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  void _getCurrentTime() {
    if (!mounted) return;

    setState(() {
      _timeString = DateFormat("HH:mm:ss").format(DateTime.now()).replaceAll(":", " : ");
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    double currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.mainGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(500, 120),
                  bottomRight: Radius.elliptical(500, 120),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: currentHeight * 0.082),
                  CircleAvatar(
                    radius: 75, // karena 150/2
                    backgroundColor:
                        userState.user!.profilePhoto == null
                            ? AppColors.mainGrey.withValues(alpha: 0.9)
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
                  SizedBox(height: 8),
                  Text(
                    "MORNING",
                    style: AppTextStyles.heading4(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppColors.mainWhite,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      userState.user!.name,
                      style: AppTextStyles.body1(
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainWhite.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 44),
                    child: Text(
                      userState.user!.training!.title,
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainWhite.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_pin, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          "Office Location",
                          style: AppTextStyles.body4(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Jl. Karet Pasar Baru Barat V No. 23, Kelurahan Karet Tengsin, Kecamatan Tanah Abang, Kota Jakarta Pusat",
                        maxLines: 2,
                        style: AppTextStyles.body4(
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainBlack,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.mainGrey,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        _timeString,
                        style: AppTextStyles.heading2(
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainWhite,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Today's Attendance",
                        style: AppTextStyles.body2(
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainWhite,
                        ),
                      ),
                      SizedBox(height: 4),
                      _buildCheckInOutCard(),
                    ],
                  ),
                ),
                SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.history),
                          SizedBox(width: 8),
                          Text(
                            "Attendance History",
                            style: AppTextStyles.body1(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainBlack,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "See All",
                        style: AppTextStyles.body3(
                          fontWeight: FontWeight.w500,
                          color: AppColors.mainLightBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: CheckInCardWidget(),
                    );
                  },
                ),
                SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildCheckInOutCard() {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.mainBlack.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Check In",
                style: AppTextStyles.body4(fontWeight: FontWeight.w600, color: AppColors.mainWhite),
              ),
              SizedBox(height: 4),
              Text(
                "07 : 50 : 00",
                style: AppTextStyles.body2(fontWeight: FontWeight.w700, color: AppColors.mainWhite),
              ),
            ],
          ),
          Container(width: 1, height: 40, color: AppColors.mainWhite),
          Column(
            children: [
              Text(
                "Check Out",
                style: AppTextStyles.body4(fontWeight: FontWeight.w600, color: AppColors.mainWhite),
              ),
              SizedBox(height: 4),
              Text(
                "17 : 50 : 00",
                style: AppTextStyles.body2(fontWeight: FontWeight.w700, color: AppColors.mainWhite),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
