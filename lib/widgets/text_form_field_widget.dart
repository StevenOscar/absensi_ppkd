import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final bool? enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onEditingComplete;
  final Icon? prefixIcon;
  final EdgeInsets? contentPadding;
  final Function(String)? onChanged;
  final double? radius;
  final int? maxlines;
  final bool? filled;
  final Widget? suffixIcon;
  final String hintText;
  final String? errorText;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.validator,
    this.obscureText,
    this.keyboardType,
    this.inputFormatters,
    this.onEditingComplete,
    this.prefixIcon,
    this.contentPadding,
    this.onChanged,
    this.radius,
    this.maxlines,
    this.suffixIcon,
    this.filled,
    required this.hintText,
    required this.errorText,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText ?? false,
      textInputAction: TextInputAction.next,
      enabled: enabled ?? true,
      onChanged: onChanged,
      maxLines: maxlines,
      style: AppTextStyles.body2(fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        errorText: errorText,
        errorStyle: AppTextStyles.body4(fontWeight: FontWeight.w500),
        errorMaxLines: 2,
        isDense: true,
        hintText: hintText,
        hintStyle: AppTextStyles.body2(fontWeight: FontWeight.w400, color: Colors.grey.shade600),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.all(16),
        filled: filled ?? true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.mainRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.mainRed, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.mainGrey, width: 1.5),
        ),
      ),
    );
  }
}
