import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: AppColors.mainGrey,
        title: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text(
            "Attendance History",
            style: AppTextStyles.heading3(fontWeight: FontWeight.w700, color: AppColors.mainWhite),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(60, 20)),
        ),
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.mainGrey,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.mainLightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w800,
                              color: AppColors.mainWhite,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "10",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w600,
                              color: AppColors.mainWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.mainLightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Present",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w800,
                              color: AppColors.mainWhite,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "5",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w600,
                              color: AppColors.mainWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.mainLightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Absent",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w800,
                              color: AppColors.mainWhite,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "5",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w600,
                              color: AppColors.mainWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 50,
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
          ],
        ),
      ),
    );
  }
}
