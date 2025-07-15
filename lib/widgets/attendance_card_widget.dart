import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/models/attendance_model.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/datetime_formatter.dart';
import 'package:absensi_ppkd/utils/word_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AttendanceCardWidget extends ConsumerWidget {
  final AttendanceModel data;
  const AttendanceCardWidget({super.key, required this.data});

  void showAttendanceDialog(BuildContext context, AttendanceModel attendance) {
    final dateFormatter = DateFormat("EEEE, dd MMM yyyy");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Attendance Details",
              style: AppTextStyles.heading3(fontWeight: FontWeight.w700, color: AppColors.mainGrey),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow("Date", dateFormatter.format(attendance.attendanceDate)),
                _buildRow("Status", attendance.status ?? "-"),
                if (attendance.status?.toLowerCase() == "izin" && attendance.alasanIzin != null)
                  _buildRow("Reason", attendance.alasanIzin ?? "-"),
                const Divider(),
                _buildRow("Check In Time", attendance.checkInTime ?? "-- : --"),
                _buildRow("Check In Location", attendance.checkInLocation ?? "-"),
                _buildRow("Check In Address", attendance.checkInAddress ?? "-"),
                const SizedBox(height: 12),
                _buildRow("Check Out Time", attendance.checkOutTime ?? "-- : --"),
                _buildRow("Check Out Location", attendance.checkOutLocation ?? "-"),
                _buildRow("Check Out Address", attendance.checkOutAddress ?? "-"),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Close")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showAttendanceDialog(context, data);
      },
      child: Card(
        elevation: 4,
        color: AppColors.mainGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.mainGrey,
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.mainLightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(right: 16),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DatetimeFormatter.formatDay(data.attendanceDate),
                        style: AppTextStyles.body3(
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainWhite,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        DatetimeFormatter.formatDate(data.attendanceDate),
                        style: AppTextStyles.heading2(
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainWhite,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        DatetimeFormatter.formatMonth(data.attendanceDate),
                        style: AppTextStyles.body3(
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainWhite,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Check In",
                              style: AppTextStyles.body3(
                                fontWeight: FontWeight.w600,
                                color: AppColors.mainWhite,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              data.checkInTime ?? "-- : --",
                              style: AppTextStyles.body1(
                                fontWeight: FontWeight.w600,
                                color: AppColors.mainWhite,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Container(width: 2, height: 40, color: AppColors.mainWhite),
                        SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Check Out",
                              style: AppTextStyles.body3(
                                fontWeight: FontWeight.w600,
                                color: AppColors.mainWhite,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              data.checkOutTime ?? "-- : --",
                              style: AppTextStyles.body1(
                                fontWeight: FontWeight.w600,
                                color: AppColors.mainWhite,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              data.status == "masuk"
                                  ? data.checkOutTime == null
                                      ? Colors.orange.shade700
                                      : AppColors.mainGreen.shade700
                                  : AppColors.mainRed.shade700,
                          width: 3,
                        ),
                        color:
                            data.status == "masuk"
                                ? data.checkOutTime == null
                                    ? Colors.orange.shade600
                                    : AppColors.mainGreen.shade500
                                : AppColors.mainRed.shade500,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Row(
                        children: [
                          Text(
                            "Status: ",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mainWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: Text(
                              WordFormatter.capitalize(
                                (data.status == "izin"
                                    ? "Leave"
                                    : data.checkOutTime != null
                                    ? "Present"
                                    : data.checkInTime != null
                                    ? "No Check-Out"
                                    : "No Check-In"),
                              ),
                              style: AppTextStyles.body2(
                                fontWeight: FontWeight.w500,
                                color: AppColors.mainWhite,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "$label:",
            style: AppTextStyles.body3(fontWeight: FontWeight.w500, color: AppColors.mainBlack),
          ),
        ),
        Expanded(flex: 5, child: Text(value)),
      ],
    ),
  );
}
