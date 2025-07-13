import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/attendance_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/widgets/attendance_card_widget.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadStats();
      await loadHistory();
    });
    super.initState();
  }

  Future<void> loadHistory() async {
    setState(() {
      isLoadingHistory = true;
    });
    await ref.read(attendanceProvider.notifier).fetchAttendanceHistory(fToast: fToast);

    setState(() {
      isLoadingHistory = false;
    });
  }

  Future<void> loadStats() async {
    setState(() {
      isLoadingStats = true;
    });
    await ref.read(attendanceProvider.notifier).fetchAttendanceStats(fToast: fToast);

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
            SizedBox(height: 20),
            isLoadingStats
                ? CircularProgressIndicator()
                : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.mainGrey,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.mainLightBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total",
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.mainWhite,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                attendanceState.attendanceStats == null
                                    ? "-"
                                    : (attendanceState.attendanceStats!.totalAbsen ?? 0).toString(),
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.mainLightBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Present",
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.mainWhite,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                attendanceState.attendanceStats == null
                                    ? "-"
                                    : (attendanceState.attendanceStats!.totalMasuk ?? 0).toString(),
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.mainLightBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Absent",
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.mainWhite,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                attendanceState.attendanceStats == null
                                    ? "-"
                                    : (attendanceState.attendanceStats!.totalIzin ?? 0).toString(),
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButtonWidget(
                      text: "Select Date Range",
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
                      items: [
                        DropdownMenuItem(value: null, child: Text("All")),
                        DropdownMenuItem(value: "masuk", child: Text("Present")),
                        DropdownMenuItem(value: "no checkout", child: Text("Not Checked Out")),
                        DropdownMenuItem(value: "izin", child: Text("Leave")),
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
                ? CircularProgressIndicator()
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
}
