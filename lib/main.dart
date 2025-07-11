import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/constants/app_routes.dart';
import 'package:absensi_ppkd/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // OneSignal.initialize("9955bcc4-5061-4e60-b304-dbaca583d39f");
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi PPKD',
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainLightBlue)),
      routes: AppRoutes.routes,
    );
  }
}
