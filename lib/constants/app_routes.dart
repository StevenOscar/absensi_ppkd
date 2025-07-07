import 'package:absensi_ppkd/screens/main_screen.dart';
import 'package:absensi_ppkd/screens/login_screen.dart';
import 'package:absensi_ppkd/screens/dashboard_screen.dart';
import 'package:absensi_ppkd/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.id: (context) => SplashScreen(),
    LoginScreen.id: (context) => LoginScreen(),
    DashboardScreen.id: (context) => DashboardScreen(),
    MainScreen.id: (context) => MainScreen(),
  };
}
