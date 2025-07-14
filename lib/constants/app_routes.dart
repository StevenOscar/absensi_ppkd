import 'package:absensi_ppkd/screens/auth/login_screen.dart';
import 'package:absensi_ppkd/screens/auth/register_screen.dart';
import 'package:absensi_ppkd/screens/check_in_out/check_in_out_screen.dart';
import 'package:absensi_ppkd/screens/dashboard_screen.dart';
import 'package:absensi_ppkd/screens/main_screen.dart';
import 'package:absensi_ppkd/screens/profile/edit_profile_screen.dart';
import 'package:absensi_ppkd/screens/profile/enter_email_screen.dart';
import 'package:absensi_ppkd/screens/profile/request_otp_screen.dart';
import 'package:absensi_ppkd/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.id: (context) => SplashScreen(),
    LoginScreen.id: (context) => LoginScreen(),
    DashboardScreen.id: (context) => DashboardScreen(),
    MainScreen.id: (context) => MainScreen(),
    CheckInOutScreen.id: (context) => CheckInOutScreen(),
    RegisterScreen.id: (context) => RegisterScreen(),
    EditProfileScreen.id: (context) => EditProfileScreen(),
    RequestOtpScreen.id: (context) => RequestOtpScreen(),
    EnterEmailScreen.id: (context) => EnterEmailScreen(),
  };
}
