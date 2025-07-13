import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/attendance_provider.dart';
import 'package:absensi_ppkd/providers/location_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
import 'package:absensi_ppkd/utils/datetime_formatter.dart';
import 'package:absensi_ppkd/widgets/attendance_card_widget.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckInOutScreen extends ConsumerStatefulWidget {
  static const String id = "/check_in";
  const CheckInOutScreen({super.key});

  @override
  ConsumerState<CheckInOutScreen> createState() => _CheckInOutScreenState();
}

class _CheckInOutScreenState extends ConsumerState<CheckInOutScreen> {
  final FToast fToast = FToast();
  bool isLoadingToday = false;
  bool isLoadingAttendance = false;

  @override
  void initState() {
    fToast.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadToday();
    });
    super.initState();
  }

  Future<void> loadToday() async {
    setState(() {
      isLoadingToday = true;
    });

    await ref.read(attendanceProvider.notifier).fetchTodayAttendance(fToast: fToast);

    setState(() {
      isLoadingToday = false;
    });
  }

  Future<void> checkInOut({required bool isCheckIn}) async {
    final locationState = ref.read(locationProvider);
    setState(() {
      isLoadingAttendance = true;
    });
    if (isCheckIn) {
      final checkIn = await ref
          .read(attendanceProvider.notifier)
          .checkIn(
            fToast: fToast,
            address: locationState.currentAddress,
            attendanceDate: DatetimeFormatter.formatYearMonthDay(DateTime.now()),
            checkInTime: DatetimeFormatter.formatHourMinute(DateTime.now()),
            checkInLat: locationState.currentPosition!.latitude,
            checkInLng: locationState.currentPosition!.longitude,
          );
      if (checkIn) {
        AppToast.showSuccessToast(fToast, "Check In Success!");
      }
    } else {
      final checkOut = await ref
          .read(attendanceProvider.notifier)
          .checkOut(
            fToast: fToast,
            address: locationState.currentAddress,
            attendanceDate: DatetimeFormatter.formatYearMonthDay(DateTime.now()),
            checkOutTime: DatetimeFormatter.formatHourMinute(DateTime.now()),
            checkOutLat: locationState.currentPosition!.latitude,
            checkOutLng: locationState.currentPosition!.longitude,
          );
      if (checkOut) {
        AppToast.showSuccessToast(fToast, "Check Out Success!");
      }
    }

    await ref.read(attendanceProvider.notifier).fetchTodayAttendance(fToast: fToast);
    await ref.read(attendanceProvider.notifier).fetchAttendanceHistory(fToast: fToast);
    await ref.read(attendanceProvider.notifier).fetchAttendanceStats(fToast: fToast);

    setState(() {
      isLoadingAttendance = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    final locationState = ref.watch(locationProvider);
    final attendanceState = ref.watch(attendanceProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(locationProvider.notifier).stopTrackingLocation();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          backgroundColor: AppColors.mainGrey,
          title: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Check In/Out",
              style: AppTextStyles.heading3(
                fontWeight: FontWeight.w700,
                color: AppColors.mainWhite,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(60, 20)),
          ),
          toolbarHeight: 70,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: AppColors.mainWhite),
          ),
        ),
        body: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              leading: SizedBox(),
              floating: false,
              pinned: true,
              toolbarHeight: currentHeight * 0.4,
              flexibleSpace: Container(
                margin: EdgeInsets.only(left: 24, right: 24, top: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainGrey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
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
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 4),
                    Text(
                      "Distance to Workplace",
                      style: AppTextStyles.body3(
                        fontWeight: FontWeight.w400,
                        color: AppColors.mainBlack,
                      ),
                    ),
                    Text(
                      "${(locationState.distanceInMeter ?? 0).toStringAsFixed(2)} M",
                      style: AppTextStyles.body1(
                        fontWeight: FontWeight.w800,
                        color: AppColors.mainBlack,
                      ),
                    ),
                    SizedBox(height: 12),
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
                    isLoadingToday
                        ? Center(child: CircularProgressIndicator())
                        : AttendanceCardWidget(data: attendanceState.todayAttendance!),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child:
                          isLoadingAttendance
                              ? Center(child: CircularProgressIndicator())
                              : ElevatedButtonWidget(
                                onPressed:
                                    (locationState.distanceInMeter ?? 100) < 100 &&
                                            attendanceState.todayAttendance!.status != "izin" &&
                                            (attendanceState.todayAttendance!.checkInTime == null ||
                                                attendanceState.todayAttendance!.checkOutTime ==
                                                    null)
                                        ? () {
                                          if (attendanceState.todayAttendance!.checkInTime ==
                                              null) {
                                            checkInOut(isCheckIn: true);
                                          } else {
                                            checkInOut(isCheckIn: false);
                                          }
                                        }
                                        : null,
                                text:
                                    attendanceState.todayAttendance!.status == "izin"
                                        ? "Already took leave today"
                                        : attendanceState.todayAttendance!.checkInTime == null
                                        ? "Check In"
                                        : attendanceState.todayAttendance!.checkOutTime == null
                                        ? "Check Out"
                                        : "Already Checked In/Out Today",
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
