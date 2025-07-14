import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/attendance_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/attendance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late final FToast fToast = FToast();
  bool isLoadingStats = false;
  bool isLoadingHistory = false;
  String? status;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    fToast.init(context);
    loadStats();
    loadHistory();
    super.initState();
  }

  Future<void> loadHistory() async {
    if (!mounted) return;
    setState(() {
      isLoadingHistory = true;
    });
    await ref.read(attendanceProvider.notifier).fetchAttendanceHistory(fToast: fToast);
    if (!mounted) return;
    setState(() {
      isLoadingHistory = false;
    });
  }

  Future<void> loadStats() async {
    if (!mounted) return;
    setState(() {
      isLoadingStats = true;
    });
    await ref.read(attendanceProvider.notifier).fetchAttendanceStats(fToast: fToast);
    if (!mounted) return;
    setState(() {
      isLoadingStats = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final attendanceState = ref.watch(attendanceProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: AppColors.mainGrey,
        title: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text(
            "Attendance History",
            style: AppTextStyles.heading3(fontWeight: FontWeight.w700, color: AppColors.mainWhite),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(60, 20)),
        ),
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoadingStats
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: AppColors.mainGrey),
                        SizedBox(height: 8),
                        Text(
                          "Loading Attendance Stats...",
                          style: AppTextStyles.body2(
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.mainGrey,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Row(
                    children: [
                      buildStatsRow(
                        attendanceState: attendanceState,
                        count: attendanceState.attendanceStats!.totalAbsen,
                        title: "Total",
                        color: AppColors.mainLightBlue,
                      ),
                      buildStatsRow(
                        attendanceState: attendanceState,
                        count: attendanceState.attendanceStats!.totalMasuk,
                        title: "Present",
                        color: AppColors.mainGreen.shade500,
                      ),
                      buildStatsRow(
                        attendanceState: attendanceState,
                        count: attendanceState.attendanceStats!.totalIzin,
                        title: "Absent",
                        color: AppColors.mainRed.shade500,
                      ),
                    ],
                  ),
                ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.date_range_outlined, color: AppColors.mainLightBlue),
                      onPressed: () async {
                        final DateTimeRange? selectedDateRange = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(3000),
                        );
                        if (selectedDateRange != null) {
                          setState(() {
                            startDate = selectedDateRange.start;
                            endDate = selectedDateRange.end;
                            ref
                                .read(attendanceProvider.notifier)
                                .filterList(
                                  startDate: selectedDateRange.start,
                                  endDate: selectedDateRange.end,
                                  status: status,
                                );
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      value: status,
                      borderRadius: BorderRadius.circular(10),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            "All",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w800,
                              color: AppColors.mainGrey,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        DropdownMenuItem(
                          value: "masuk",
                          child: Text(
                            "Present",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w800,
                              color: AppColors.mainGreen.shade700,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "no checkout",
                          child: Text(
                            "Not Checked Out",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w800,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "izin",
                          child: Text(
                            "Leave",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w800,
                              color: AppColors.mainRed.shade700,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) async {
                        setState(() {
                          status = value;
                        });
                        await ref
                            .read(attendanceProvider.notifier)
                            .filterList(startDate: startDate, endDate: endDate, status: status);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            isLoadingHistory
                ? SizedBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: AppColors.mainGrey),
                          SizedBox(height: 8),
                          Text(
                            "Loading Attendance History...",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w600,
                              color: AppColors.mainGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : status == null && startDate == null && endDate == null
                ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: attendanceState.fullAttendanceList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: AttendanceCardWidget(data: attendanceState.fullAttendanceList![index]),
                    );
                  },
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: attendanceState.filteredAttendanceList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: AttendanceCardWidget(
                        data: attendanceState.filteredAttendanceList![index],
                      ),
                    );
                  },
                ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Expanded buildStatsRow({
    required AttendanceState attendanceState,
    required String title,
    required int? count,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.body2(fontWeight: FontWeight.w800, color: AppColors.mainWhite),
            ),
            SizedBox(height: 2),
            Text(
              attendanceState.attendanceStats == null ? "-" : (count ?? 0).toString(),
              style: AppTextStyles.body2(fontWeight: FontWeight.w600, color: AppColors.mainWhite),
            ),
          ],
        ),
      ),
    );
  }
}
