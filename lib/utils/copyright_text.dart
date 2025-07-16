import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:flutter/widgets.dart';

class CopyrightText {
  static Padding build = Padding(
    padding: const EdgeInsets.only(top: 40),
    child: Center(
      child: Text(
        "©2025 Steven Oscar. All rights reserved.",
        style: AppTextStyles.body3(fontWeight: FontWeight.w400),
      ),
    ),
  );
}
