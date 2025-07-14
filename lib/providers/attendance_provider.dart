import 'package:absensi_ppkd/api/absen_api.dart';
import 'package:absensi_ppkd/models/attendance_model.dart';
import 'package:absensi_ppkd/models/attendance_stats_model.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
import 'package:absensi_ppkd/utils/datetime_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

final attendanceProvider = NotifierProvider<AttendanceProvider, AttendanceState>(
  () => AttendanceProvider(),
);

class AttendanceState {
  final List<AttendanceModel>? fullAttendanceList;
  final List<AttendanceModel>? filteredAttendanceList;
  final AttendanceModel? todayAttendance;
  final AttendanceStatsModel? attendanceStats;

  const AttendanceState({
    this.fullAttendanceList,
    this.filteredAttendanceList,
    this.todayAttendance,
    this.attendanceStats,
  });

  AttendanceState copyWith({
    List<AttendanceModel>? fullAttendanceList,
    List<AttendanceModel>? filteredAttendanceList,
    AttendanceModel? todayAttendance,
    AttendanceStatsModel? attendanceStats,
  }) {
    return AttendanceState(
      fullAttendanceList: fullAttendanceList ?? this.fullAttendanceList,
      todayAttendance: todayAttendance ?? this.todayAttendance,
      attendanceStats: attendanceStats ?? this.attendanceStats,
      filteredAttendanceList: filteredAttendanceList ?? this.filteredAttendanceList,
    );
  }
}

class AttendanceProvider extends Notifier<AttendanceState> {
  @override
  AttendanceState build() => const AttendanceState();

  Future<bool> checkIn({
    required FToast fToast,
    required String attendanceDate,
    required String checkInTime,
    required String address,
    required double checkInLat,
    required double checkInLng,
  }) async {
    try {
      final res = await AbsenApi.postCheckIn(
        attendanceDate: attendanceDate,
        checkInTime: checkInTime,
        checkInLat: checkInLat,
        checkInLng: checkInLng,
        address: address,
      );
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(fToast, errorList);
        return false;
      } else if (res.data != null) {
        return true;
      } else {
        AppToast.showErrorToast(fToast, res.message);
        return false;
      }
    } catch (e) {
      AppToast.showErrorToast(fToast, e.toString());
      return false;
    }
  }

  Future<bool> checkOut({
    required FToast fToast,
    required String attendanceDate,
    required String checkOutTime,
    required String address,
    required double checkOutLat,
    required double checkOutLng,
  }) async {
    try {
      final res = await AbsenApi.postCheckOut(
        attendanceDate: attendanceDate,
        checkOutLat: checkOutLat,
        checkOutLng: checkOutLng,
        checkOutTime: checkOutTime,
        address: address,
      );
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(fToast, errorList);
        return false;
      } else if (res.data != null) {
        return true;
      } else {
        AppToast.showErrorToast(fToast, res.message);
        return false;
      }
    } catch (e) {
      AppToast.showErrorToast(fToast, e.toString());
      return false;
    }
  }

  Future<bool> fetchAttendanceHistory({
    String? startDate,
    String? endDate,
    required FToast fToast,
  }) async {
    try {
      final res = await AbsenApi.getAttendanceHistory(startDate: startDate, endDate: endDate);
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(fToast, errorList);
        return false;
      } else if (res.data != null) {
        state = state.copyWith(fullAttendanceList: res.data);
        return true;
      } else {
        AppToast.showErrorToast(fToast, res.message);
        return false;
      }
    } catch (e) {
      AppToast.showErrorToast(fToast, e.toString());
      return false;
    }
  }

  Future<bool> fetchTodayAttendance({required FToast fToast}) async {
    try {
      final res = await AbsenApi.getTodayAttendance(
        date: DatetimeFormatter.formatYearMonthDay(DateTime.now()),
      );
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(fToast, errorList);
        return false;
      } else if (res.data != null) {
        state = state.copyWith(todayAttendance: res.data);
        return true;
      } else {
        state = state.copyWith(
          todayAttendance: AttendanceModel(
            attendanceDate: DateTime.now(),
            checkInTime: null,
            checkOutTime: null,
            checkInLat: null,
            checkInLng: null,
            checkOutLat: null,
            checkOutLng: null,
            checkInAddress: null,
            checkOutAddress: null,
            checkInLocation: null,
            checkOutLocation: null,
            status: null,
            alasanIzin: null,
          ),
        );
        AppToast.showErrorToast(fToast, res.message.replaceFirst("tanggal tersebut", "hari ini"));
        return false;
      }
    } catch (e) {
      AppToast.showErrorToast(fToast, e.toString());
      return false;
    }
  }

  Future<bool> fetchAttendanceStats({required FToast fToast}) async {
    try {
      final res = await AbsenApi.getAttendanceStats();
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(fToast, errorList);
        return false;
      } else if (res.data != null) {
        state = state.copyWith(attendanceStats: res.data);
        return true;
      } else {
        state = state.copyWith(
          attendanceStats: AttendanceStatsModel(
            totalAbsen: null,
            totalMasuk: null,
            totalIzin: null,
            sudahAbsenHariIni: null,
          ),
        );
        AppToast.showErrorToast(fToast, res.message.replaceFirst("tanggal tersebut", "hari ini"));
        return false;
      }
    } catch (e) {
      AppToast.showErrorToast(fToast, e.toString());
      return false;
    }
  }

  Future<bool> leavePermission({
    required FToast fToast,
    required String date,
    required String reason,
  }) async {
    try {
      final res = await AbsenApi.postLeavePermission(date: date, reason: reason);
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(fToast, errorList);
        return false;
      } else if (res.data != null) {
        return true;
      } else {
        AppToast.showErrorToast(fToast, res.message);
        return false;
      }
    } catch (e) {
      AppToast.showErrorToast(fToast, e.toString());
      return false;
    }
  }

  Future<void> filterList({DateTime? startDate, DateTime? endDate, String? status}) async {
    final filteredAttendance =
        state.fullAttendanceList?.where((t) {
          bool isStatus = true;
          final tDate = DateTime(
            t.attendanceDate.year,
            t.attendanceDate.month,
            t.attendanceDate.day,
          );
          final isInDateRange =
              tDate.isAfter((startDate ?? DateTime(2000)).subtract(Duration(days: 1))) &&
              tDate.isBefore((endDate ?? DateTime(3000)).add(Duration(days: 1)));
          if (status != null) {
            if (status == "no checkout") {
              if (t.status == "masuk" && t.checkInTime != null && t.checkOutTime == null) {
                isStatus = true;
              } else {
                isStatus = false;
              }
            } else {
              isStatus = t.status!.contains(status);
              if (t.checkOutTime == null && t.status == "masuk") {
                isStatus = false;
              }
            }
          }
          return isInDateRange && isStatus;
        }).toList();
    state = state.copyWith(
      filteredAttendanceList: filteredAttendance,
      attendanceStats: AttendanceStatsModel(
        totalAbsen: filteredAttendance!.length,
        totalMasuk: filteredAttendance.where((element) => element.status == "masuk").length,
        totalIzin: filteredAttendance.where((element) => element.status == "izin").length,
      ),
    );
  }
}
