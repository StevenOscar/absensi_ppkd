import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static final FToast _fToast = FToast();

  static void showErrorToast(BuildContext context, String message) {
    final fToast = FToast();
    fToast.init(context);
    _fToast.removeCustomToast();
    _fToast.showToast(
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
      child: _buildToastContainer(
        icon: Icons.cancel_rounded,
        color: AppColors.mainRed,
        borderColor: AppColors.mainRed.shade900,
        message: message,
      ),
    );
  }

  static void showErrorListToast(BuildContext context, List<String> errors) {
    final fToast = FToast();
    fToast.init(context);
    _fToast.removeCustomToast();
    _fToast.showToast(
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
                    errors
                        .map(
                          (e) => Text(
                            e,
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w600,
                              color: AppColors.mainWhite,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showSuccessToast(BuildContext context, String message) {
    final fToast = FToast();
    fToast.init(context);
    _fToast.removeCustomToast();
    _fToast.showToast(
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
      child: _buildToastContainer(
        icon: Icons.check,
        color: AppColors.mainGreen,
        message: message,
        borderRadius: 20,
      ),
    );
  }

  static Widget _buildToastContainer({
    required IconData icon,
    required Color color,
    required String message,
    Color? borderColor,
    double borderRadius = 10,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.mainWhite, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body2(fontWeight: FontWeight.w600, color: AppColors.mainWhite),
            ),
          ),
        ],
      ),
    );
  }
}
