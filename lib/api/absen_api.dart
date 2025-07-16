import 'dart:convert';
import 'dart:io';

import 'package:absensi_ppkd/constants/endpoint.dart';
import 'package:absensi_ppkd/helper/shared_pref_helper.dart';
import 'package:absensi_ppkd/models/attendance_model.dart';
import 'package:absensi_ppkd/models/attendance_stats_model.dart';
import 'package:absensi_ppkd/models/response_model.dart';
import 'package:http/http.dart' as http;

class AbsenApi {
  static Future<ResponseModel<AttendanceModel>> postCheckIn({
    required String attendanceDate,
    required String checkInTime,
    required double checkInLat,
    required double checkInLng,
    required String address,
  }) async {
    final token = await SharedPrefHelper.getToken();
    if (token.isEmpty) {
      throw "Token not found, Please Re-login";
    }
    final response = await http.post(
      Uri.parse(Endpoint.absenCheckIn),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "attendance_date": attendanceDate,
        "check_in": checkInTime,
        "check_in_lat": checkInLat,
        "check_in_lng": checkInLng,
        "check_in_address": address,
        "status": "masuk",
      }),
    );
    if (response.statusCode == 200) {
      return ResponseModel.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => AttendanceModel.fromJson(x),
      );
    } else if (response.statusCode == 409) {
      return ResponseModel.fromJson(json: jsonDecode(response.body));
    } else {
      throw Exception("Error Check In:  ${response.statusCode}");
    }
  }

  static Future<ResponseModel<AttendanceModel>> postCheckOut({
    required String attendanceDate,
    required String checkOutTime,
    required double checkOutLat,
    required double checkOutLng,
    required String address,
  }) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        throw "Token not found, Please Re-login";
      }
      final response = await http.post(
        Uri.parse(Endpoint.absenCheckOut),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "attendance_date": attendanceDate,
          "check_out": checkOutTime,
          "check_out_lat": checkOutLat.toString(),
          "check_out_lng": checkOutLng.toString(),
          "check_out_location": "$checkOutLat, $checkOutLng",
          "check_out_address": address,
        }),
      );
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(
          json: jsonDecode(response.body),
          fromJsonT: (x) => AttendanceModel.fromJson(x),
        );
      } else if (response.statusCode == 409 || response.statusCode == 404) {
        return ResponseModel.fromJson(json: jsonDecode(response.body));
      } else {
        throw Exception(
          "Error Check Out:  ${response.statusCode} \n${jsonDecode(response.body)["message"]}",
        );
      }
    } on SocketException catch (e) {
      throw Exception("Error Check Out:  $e");
    }
  }

  static Future<ResponseModel<bool>> deleteAttendance({required int id}) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        throw "Token not found, Please Re-login";
      }
      final response = await http.delete(
        Uri.parse("${Endpoint.absen}/$id"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        return ResponseModel<bool>(message: jsonDecode(response.body), data: true);
      } else if (response.statusCode == 404) {
        return ResponseModel.fromJson(json: jsonDecode(response.body));
      } else {
        throw Exception(
          "Error Delete Attendance:  ${response.statusCode} \n${jsonDecode(response.body)["message"]}",
        );
      }
    } on SocketException catch (e) {
      throw Exception("Error Delete Attendance:  $e");
    }
  }

  static Future<ResponseModel<AttendanceModel>> postLeavePermission({
    required String date,
    required String reason,
  }) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        throw "Token not found, Please Re-login";
      }
      final response = await http.post(
        Uri.parse(Endpoint.izin),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"date": date, "alasan_izin": reason}),
      );
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(
          json: jsonDecode(response.body),
          fromJsonT: (x) => AttendanceModel.fromJson(x),
        );
      } else if (response.statusCode == 409) {
        return ResponseModel.fromJson(json: jsonDecode(response.body));
      } else {
        throw Exception(
          "Error Izin:  ${response.statusCode} \n${jsonDecode(response.body)["message"]}",
        );
      }
    } on SocketException catch (e) {
      throw Exception("Error Izin:  $e");
    }
  }

  static Future<ResponseModel<AttendanceModel>> getTodayAttendance({required String date}) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        throw "Token not found, Please Re-login";
      }
      final response = await http.get(
        Uri.parse(Endpoint.absenToday).replace(queryParameters: {'attendance_date': date}),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(
          json: jsonDecode(response.body),
          fromJsonT: (x) => AttendanceModel.fromJson(x),
        );
      } else if (response.statusCode == 404) {
        return ResponseModel.fromJson(json: jsonDecode(response.body));
      } else {
        throw Exception(
          "Error Get Today:  ${response.statusCode} \n${jsonDecode(response.body)["message"]}",
        );
      }
    } on SocketException catch (e) {
      throw Exception("Error Get Today:  $e");
    }
  }

  static Future<ResponseModel<List<AttendanceModel>>> getAttendanceHistory({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        throw "Token not found, Please Re-login";
      }
      final response = await http.get(
        Uri.parse(Endpoint.absenHistory).replace(
          queryParameters: {
            if (startDate != null) 'start': startDate,
            if (endDate != null) 'end': endDate,
          },
        ),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        return ResponseModel.listFromJson<AttendanceModel>(
          json: jsonDecode(response.body),
          fromJsonT: (x) => AttendanceModel.fromJson(x),
        );
      } else if (response.statusCode == 404) {
        return ResponseModel.fromJson(json: jsonDecode(response.body));
      } else {
        throw Exception(
          "Error Attendance History:  ${response.statusCode} \n${jsonDecode(response.body)["message"]}",
        );
      }
    } on SocketException catch (e) {
      throw Exception("Error Attendance History:  $e");
    }
  }

  static Future<ResponseModel<AttendanceStatsModel>> getAttendanceStats() async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        throw "Token not found, Please Re-login";
      }
      final response = await http.get(
        Uri.parse(Endpoint.absenStats),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(
          json: jsonDecode(response.body),
          fromJsonT: (x) => AttendanceStatsModel.fromJson(x),
        );
      } else if (response.statusCode == 404) {
        return ResponseModel.fromJson(json: jsonDecode(response.body));
      } else {
        throw Exception(
          "Error Attendance Stats:  ${response.statusCode} \n${jsonDecode(response.body)["message"]}",
        );
      }
    } on SocketException catch (e) {
      throw Exception("Error Attendance Stats:  $e");
    }
  }
}
