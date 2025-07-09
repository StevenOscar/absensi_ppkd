import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/constants/assets_images.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/check_in_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const String id = "/dsahboard";
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
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
                  SizedBox(height: currentHeight * 0.085),
                  CircleAvatar(radius: 50, backgroundImage: AssetImage(AssetsImages.imagesStudent)),
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
                  Text(
                    userState.user!.name,
                    style: AppTextStyles.body2(
                      fontWeight: FontWeight.w500,
                      color: AppColors.mainWhite,
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 44),
                    child: Text(
                      userState.user!.training!.title,
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainWhite,
                      ),
                      textAlign: TextAlign.center,
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
                Text(
                  "Distance from workplace",
                  style: AppTextStyles.body4(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "250.43 m",
                  style: AppTextStyles.heading4(
                    fontWeight: FontWeight.w800,
                    color: AppColors.mainBlack,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 8, bottom: 12, left: 24, right: 24),
                        decoration: BoxDecoration(
                          color: AppColors.mainGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Check In",
                              style: AppTextStyles.body4(
                                fontWeight: FontWeight.w600,
                                color: AppColors.mainWhite,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "07 : 50 : 00",
                              style: AppTextStyles.body2(
                                fontWeight: FontWeight.w700,
                                color: AppColors.mainWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8, bottom: 12, left: 24, right: 24),
                        decoration: BoxDecoration(
                          color: AppColors.mainGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Check Out",
                              style: AppTextStyles.body4(
                                fontWeight: FontWeight.w600,
                                color: AppColors.mainWhite,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "17 : 50 : 00 ",
                              style: AppTextStyles.body2(
                                fontWeight: FontWeight.w700,
                                color: AppColors.mainWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_pin, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          maxLines: 2,
                          style: AppTextStyles.body4(
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                            color: AppColors.mainBlack,
                          ),
                          "Jl. Pangeran Diponegoro No 5, Kec. Medan Petisah, Kota Medan, Sumatra Utara",
                        ),
                      ),
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
}
