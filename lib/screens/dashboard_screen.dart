import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/constants/assets_images.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = "/dsahboard";
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    double currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -(currentWidth * 1.12),
              left: -(currentWidth * 0.4),
              child: CircleAvatar(
                radius: (currentWidth + (currentWidth * 0.8)) / 2,
                backgroundColor: AppColors.mainGrey,
              ),
            ),
            Column(
              children: [
                SizedBox(height: currentHeight * 0.085),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(AssetsImages.imagesStudent),
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
                    Text(
                      "Muhammad Rio Akbar",
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainWhite,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "123456789",
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainWhite,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32),
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
                          Text(
                            "Attendance History",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainBlack,
                            ),
                          ),
                          Text(
                            "Lihat Semua",
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
                          child: Card(
                            elevation: 4,
                            color: AppColors.mainGrey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.mainGrey,
                              ),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainLightBlue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: EdgeInsets.only(right: 16),
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Wednesday",
                                            style: AppTextStyles.body3(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.mainWhite,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "13 - 07 - 2025",
                                            style: AppTextStyles.body3(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.mainWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                            style: AppTextStyles.body3(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.mainWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 16),
                                      Container(
                                        width: 2,
                                        height: 40, // or whatever height you want
                                        color: AppColors.mainWhite,
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                            "17 : 50 : 00",
                                            style: AppTextStyles.body3(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.mainWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
