// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final double? radius;
  final double? elevation;
  final double? verticalPadding;
  const ElevatedButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.radius,
    this.verticalPadding, this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 0,
        backgroundColor: backgroundColor ?? AppColors.mainLightBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 25)),
        padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 12),
      ),
      child: Text(
        text,
        style: AppTextStyles.body2(fontWeight: FontWeight.w600, color: AppColors.mainWhite),
      ),
    );
  }
}
