import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/location_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/check_in_card_widget.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  static const String id = "/check_in";
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final FToast fToast = FToast();

  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    final locationState = ref.watch(locationProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(locationProvider.notifier).stopTrackingLocation();
      },
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
                initialCameraPosition: CameraPosition(
                  target: locationState.currentPosition ?? LatLng(0, 0),
                  zoom: 10,
                ),
                onMapCreated: (controller) {
                  ref.read(locationProvider.notifier).setMapController(controller);
                  ref.read(locationProvider.notifier).startTrackingLocation();
                },
                markers: locationState.marker != null ? {locationState.marker!} : {},
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                circles: {
                  Circle(
                    circleId: CircleId("target_radius"),
                    center: targetLatLng,
                    radius: 100,
                    fillColor: Colors.blue.withValues(alpha: 0.2),
                    strokeColor: Colors.blue,
                    strokeWidth: 2,
                  ),
                },
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
                            "Address : ",
                            style: AppTextStyles.body3(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainLightBlue,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text(
                            locationState.currentAddress,
                            style: AppTextStyles.body3(
                              fontWeight: FontWeight.w500,
                              color: AppColors.mainBlack,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    CheckInCardWidget(),
                    SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButtonWidget(
                        onPressed: (locationState.distanceInMeter ?? 100) < 100 ? () {} : null,
                        text: "Check In",
                      ),
                    ),
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
