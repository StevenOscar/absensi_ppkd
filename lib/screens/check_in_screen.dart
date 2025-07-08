import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/check_in_card_widget.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInScreen extends StatefulWidget {
  static const String id = "/check_in";
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: AppColors.mainGrey,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: AppColors.mainWhite),
          ),
          actionsPadding: EdgeInsets.only(right: 12),
          actions: [
            CircleAvatar(),
            SizedBox(width: 8),
            Icon(Icons.settings_outlined, color: AppColors.mainWhite, size: 30),
            SizedBox(width: 4),
            Icon(Icons.notifications, color: AppColors.mainWhite, size: 30),
          ],
          title: Text(
            "Check In",
            style: AppTextStyles.heading4(fontWeight: FontWeight.w700, color: AppColors.mainWhite),
          ),
        ),
        body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              leading: SizedBox(),
              floating: false,
              pinned: true,
              toolbarHeight: currentHeight * 0.47,
              flexibleSpace: GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(target: LatLng(0.0008, 0.555), zoom: 2),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Status  : ",
                            style: AppTextStyles.body3(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainLightBlue,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text(
                            "Belum Check In",
                            style: AppTextStyles.body3(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Alamat : ",
                            style: AppTextStyles.body3(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainLightBlue,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text(
                            "Jl. Pangeran Diponegoro No 5, Kec. Medan Petisah, Kota Medan, Sumatra Utara",
                            style: AppTextStyles.body3(
                              fontWeight: FontWeight.w500,
                              color: AppColors.mainBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    CheckInCardWidget(),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButtonWidget(onPressed: () {}, text: "Check In"),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
