import 'dart:async';

import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/attendance_provider.dart';
import 'package:absensi_ppkd/providers/navigation_provider.dart';
import 'package:absensi_ppkd/providers/user_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/copyright_text.dart';
import 'package:absensi_ppkd/utils/datetime_formatter.dart';
import 'package:absensi_ppkd/widgets/attendance_card_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const String id = "/dsahboard";
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late String _timeString;
  String greetings = "Hello!";
  bool isLoadingToday = false;
  bool isLoadingHistory = false;
  Timer? _currentTimeTimer;

  @override
  void initState() {
    loadToday();
    loadHistory();
    _timeString = DateFormat("HH:mm:ss").format(DateTime.now()).replaceAll(":", " : ");
    _currentTimeTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  @override
  void dispose() {
    _currentTimeTimer?.cancel();
    super.dispose();
  }

  Future<void> loadHistory() async {
    if (!mounted) return;
    setState(() {
      isLoadingHistory = true;
    });
    await ref.read(attendanceProvider.notifier).fetchAttendanceHistory(context: context);
    if (!mounted) return;
    setState(() {
      isLoadingHistory = false;
    });
  }

  Future<void> loadToday() async {
    if (!mounted) return;
    setState(() {
      isLoadingToday = true;
    });
    await ref.read(attendanceProvider.notifier).fetchTodayAttendance(context: context);
    if (!mounted) return;
    setState(() {
      isLoadingToday = false;
    });
  }

  void _getCurrentTime() {
    if (!mounted) return;

    setState(() {
      _timeString = DateFormat("HH:mm:ss").format(DateTime.now()).replaceAll(":", " : ");
      greetings = _getGreetingForHour(DateTime.now().hour);
    });
  }

  String _getGreetingForHour(int hour) {
    if (hour >= 5 && hour < 11) {
      return "Good Morning";
    } else if (hour >= 11 && hour < 15) {
      return "Good Afternoon";
    } else if (hour >= 15 && hour < 18) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final attendanceState = ref.watch(attendanceProvider);
    double currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          loadToday();
          loadHistory();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.mainGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(500, 120),
                    bottomRight: Radius.elliptical(500, 120),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: currentHeight * 0.082),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: ClipOval(
                        child:
                            userState.user?.profilePhoto != null
                                ? CachedNetworkImage(
                                  imageUrl:
                                      "https://appabsensi.mobileprojp.com/public/${userState.user!.profilePhoto!}",
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Container(
                                        color: AppColors.mainGrey.withValues(alpha: 0.3),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.mainWhite,
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Container(
                                        color: AppColors.mainRed.withValues(alpha: 0.3),
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            size: 70,
                                            color: AppColors.mainWhite,
                                          ),
                                        ),
                                      ),
                                )
                                : Container(
                                  color: AppColors.mainLightBlue.withValues(alpha: 0.9),
                                  child: Center(
                                    child: Icon(
                                      Icons.no_photography_outlined,
                                      size: 70,
                                      color: AppColors.mainWhite,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      greetings,
                      style: AppTextStyles.heading4(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: AppColors.mainWhite,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        userState.user!.name,
                        style: AppTextStyles.body1(
                          fontWeight: FontWeight.w500,
                          color: AppColors.mainWhite.withValues(alpha: 0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 44),
                      child: Text(
                        userState.user!.training!.title,
                        style: AppTextStyles.body2(
                          fontWeight: FontWeight.w500,
                          color: AppColors.mainWhite.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_pin, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            "Office Location",
                            style: AppTextStyles.body4(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 48, right: 48),
                        child: Text(
                          "Jl. Karet Pasar Baru Barat V No. 23, Kelurahan Karet Tengsin, Kecamatan Tanah Abang, Kota Jakarta Pusat",
                          maxLines: 2,
                          style: AppTextStyles.body4(
                            height: 1.4,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mainBlack,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainGrey,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          DatetimeFormatter.formatDayDateMonthYear(DateTime.now()),
                          style: AppTextStyles.body2(
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainWhite,
                          ),
                        ),
                        Text(
                          _timeString,
                          style: AppTextStyles.heading2(
                            fontWeight: FontWeight.w700,
                            color: AppColors.mainWhite,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Today's Attendance",
                          style: AppTextStyles.body2(
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainWhite,
                          ),
                        ),
                        SizedBox(height: 4),
                        isLoadingToday
                            ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(color: AppColors.mainWhite),
                              ),
                            )
                            : _buildCheckInOutCard(
                              checkInTime: attendanceState.todayAttendance?.checkInTime,
                              checkOutTime: attendanceState.todayAttendance?.checkOutTime,
                            ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.history, size: 30),
                            SizedBox(width: 8),
                            Text(
                              "Attendance History",
                              style: AppTextStyles.body1(
                                fontWeight: FontWeight.w700,
                                color: AppColors.mainBlack,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            ref.read(navigationProvider.notifier).setPage(currentPage: 2);
                          },
                          child: Text(
                            "See All",
                            style: AppTextStyles.body3(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainLightBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  isLoadingHistory
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: CircularProgressIndicator(color: AppColors.mainGrey),
                        ),
                      )
                      : (attendanceState.fullAttendanceList == null ||
                          attendanceState.fullAttendanceList!.isEmpty)
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.question_mark_sharp,
                                size: 64,
                                color: AppColors.mainGrey.withValues(alpha: 0.4),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No attendance Data",
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.mainGrey.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: (attendanceState.fullAttendanceList!.length).clamp(1, 5),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 4),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            child: AttendanceCardWidget(
                              data: attendanceState.fullAttendanceList![index],
                            ),
                          );
                        },
                      ),
                  CopyrightText.build,
                  SizedBox(height: 60),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCheckInOutCard({required String? checkInTime, required String? checkOutTime}) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.mainBlack.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Check In",
                style: AppTextStyles.body4(fontWeight: FontWeight.w600, color: AppColors.mainWhite),
              ),
              SizedBox(height: 4),
              Text(
                (checkInTime ?? "--:--").replaceAll("-", " - "),
                style: AppTextStyles.body2(fontWeight: FontWeight.w700, color: AppColors.mainWhite),
              ),
            ],
          ),
          Container(width: 1, height: 40, color: AppColors.mainWhite),
          Column(
            children: [
              Text(
                "Check Out",
                style: AppTextStyles.body4(fontWeight: FontWeight.w600, color: AppColors.mainWhite),
              ),
              SizedBox(height: 4),
              Text(
                (checkOutTime ?? "--:--").replaceAll("-", " - "),
                style: AppTextStyles.body2(fontWeight: FontWeight.w700, color: AppColors.mainWhite),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
