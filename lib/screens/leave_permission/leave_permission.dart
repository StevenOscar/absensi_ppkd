import 'package:absensi_ppkd/constants/app_colors.dart';
import 'package:absensi_ppkd/providers/attendance_provider.dart';
import 'package:absensi_ppkd/styles/app_text_styles.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
import 'package:absensi_ppkd/utils/datetime_formatter.dart';
import 'package:absensi_ppkd/widgets/elevated_button_widget.dart';
import 'package:absensi_ppkd/widgets/text_form_field_widget.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LeavePermissionScreen extends ConsumerStatefulWidget {
  const LeavePermissionScreen({super.key});

  @override
  ConsumerState<LeavePermissionScreen> createState() => _LeavePermissionScreenState();
}

class _LeavePermissionScreenState extends ConsumerState<LeavePermissionScreen> {
  late final FToast fToast = FToast();
  DateTime? _selectedDate;
  final reasonController = TextEditingController();
  bool isLoadingAttendance = false;

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  Future<void> leavePermission() async {
    if (!mounted) return;
    setState(() {
      isLoadingAttendance = true;
    });
    final leavePermission = await ref
        .read(attendanceProvider.notifier)
        .leavePermission(
          fToast: fToast,
          date: DatetimeFormatter.formatYearMonthDay(_selectedDate!),
          reason: reasonController.text,
        );
    if (leavePermission) {
      AppToast.showSuccessToast(fToast, "Leave Request Submitted!");
    }
    _selectedDate = null;
    reasonController.clear();
    await ref.read(attendanceProvider.notifier).fetchTodayAttendance(fToast: fToast);
    await ref.read(attendanceProvider.notifier).fetchAttendanceHistory(fToast: fToast);
    await ref.read(attendanceProvider.notifier).fetchAttendanceStats(fToast: fToast);

    if (!mounted) return;
    setState(() {
      isLoadingAttendance = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: AppColors.mainGrey,
        title: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text(
            "Leave Permission",
            style: AppTextStyles.heading3(fontWeight: FontWeight.w700, color: AppColors.mainWhite),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(60, 20)),
        ),
        toolbarHeight: 70,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        children: [
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 400,
              child: DatePicker(
                splashRadius: 12,
                centerLeadingDate: true,
                minDate: DateTime.now(),
                maxDate: DateTime.now().add(const Duration(days: 14)),
                enabledCellsDecoration: BoxDecoration(
                  color: AppColors.mainLightBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                selectedCellDecoration: BoxDecoration(
                  color: AppColors.mainLightBlue,
                  borderRadius: BorderRadius.circular(25),
                ),
                currentDateDecoration: BoxDecoration(
                  color: AppColors.mainLightBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                currentDateTextStyle: AppTextStyles.body1(
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainBlack,
                ),
                disabledCellsTextStyle: AppTextStyles.body2(
                  fontWeight: FontWeight.w500,
                  color: AppColors.mainBlack.withValues(alpha: 0.4),
                ),
                enabledCellsTextStyle: AppTextStyles.body2(
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainBlack,
                ),
                daysOfTheWeekTextStyle: AppTextStyles.body3(
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainLightBlue,
                ),
                leadingDateTextStyle: AppTextStyles.heading3(fontWeight: FontWeight.w700),
                selectedCellTextStyle: AppTextStyles.body1(
                  fontWeight: FontWeight.w700,
                  color: AppColors.mainWhite,
                ),
                onDateSelected: (value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
              ),
            ),
          ),
          if (_selectedDate != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainBlack.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: AppColors.mainGrey.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Selected Date',
                    style: AppTextStyles.heading4(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    DatetimeFormatter.formatDayDateMonthYear(_selectedDate!),
                    style: AppTextStyles.body2(fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextFormFieldWidget(
                    controller: reasonController,
                    hintText: "Reason",
                    errorText: null,
                    keyboardType: TextInputType.text,
                    enabled: true,
                    maxlines: 3,
                    onChanged: (p0) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  isLoadingAttendance
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButtonWidget(
                        text: "Submit Leave Request",
                        onPressed:
                            reasonController.text.isNotEmpty
                                ? () {
                                  leavePermission();
                                }
                                : null,
                      ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
