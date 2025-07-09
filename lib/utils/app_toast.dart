import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static void showErrorToast(FToast fToast, String message) {
    fToast.showToast(
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainRed,
          border: Border.all(color: AppColors.mainRed.shade900, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.cancel_rounded, color: AppColors.mainWhite, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body2(fontWeight: FontWeight.w600, color: AppColors.mainWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showErrorListToast(FToast fToast, List<String> errors) {
    fToast.showToast(
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainRed,
          border: Border.all(color: AppColors.mainRed.shade900, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.cancel_rounded, color: AppColors.mainWhite, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    errors.map((e) {
                      return Text(
                        e,
                        style: AppTextStyles.body2(
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainWhite,
                        ),
                        textAlign: TextAlign.start,
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showSuccessToast(FToast fToast, String message) {
    fToast.showToast(
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.check, color: AppColors.mainWhite, size: 40),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body2(fontWeight: FontWeight.w600, color: AppColors.mainWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
