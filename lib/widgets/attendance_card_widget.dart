import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/models/attendance_model.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/datetime_formatter.dart';
import 'package:absensi_ppkd/utils/word_formatter.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
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
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.mainWhite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_note, color: AppColors.mainLightBlue, size: 40),
                SizedBox(height: 12),
                Text(
                  "Attendance Details",
                  style: AppTextStyles.heading3(
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18),
                Divider(thickness: 1, color: AppColors.mainGrey.withValues(alpha: 0.2)),
                SizedBox(height: 8),
                _buildRowWithIcon(
                  Icons.calendar_today,
                  "Date",
                  dateFormatter.format(attendance.attendanceDate),
                ),
                _buildRowWithIcon(Icons.info_outline, "Status", attendance.status ?? "-"),
                if (attendance.status?.toLowerCase() == "izin" && attendance.alasanIzin != null)
                  _buildRowWithIcon(Icons.help_outline, "Reason", attendance.alasanIzin ?? "-"),
                SizedBox(height: 8),
                Divider(thickness: 1, color: AppColors.mainGrey.withValues(alpha: 0.2)),
                SizedBox(height: 8),
                _buildRowWithIcon(
                  Icons.login,
                  "Check In \nTime",
                  attendance.checkInTime ?? "Not recorded",
                ),
                _buildRowWithIcon(
                  Icons.location_on_outlined,
                  "Check In \nLocation",
                  attendance.checkInLocation ?? "-",
                ),
                _buildRowWithIcon(
                  Icons.home_outlined,
                  "Check In \nAddress",
                  attendance.checkInAddress ?? "Unknown",
                ),
                SizedBox(height: 12),
                _buildRowWithIcon(
                  Icons.logout,
                  "Check Out \nTime",
                  attendance.checkOutTime ?? "Not recorded",
                ),
                _buildRowWithIcon(
                  Icons.location_on_outlined,
                  "Check Out \nLocation",
                  attendance.checkOutLocation ?? "-",
                ),
                _buildRowWithIcon(
                  Icons.home_outlined,
                  "Check Out \nAddress",
                  attendance.checkOutAddress ?? "Unknown",
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButtonWidget(
                    text: "Close",
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
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

Widget _buildRowWithIcon(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.mainGrey.withValues(alpha: 0.7)),
        SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            "$label:",
            style: AppTextStyles.body3(fontWeight: FontWeight.w700, color: AppColors.mainGrey),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: AppTextStyles.body3(fontWeight: FontWeight.w400, color: AppColors.mainBlack),
          ),
        ),
      ],
    ),
  );
}
