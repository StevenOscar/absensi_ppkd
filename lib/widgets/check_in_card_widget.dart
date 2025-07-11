import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class CheckInCardWidget extends StatelessWidget {
  const CheckInCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  height: 40,
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
    );
  }
}
