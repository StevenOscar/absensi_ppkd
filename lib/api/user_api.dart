import 'dart:convert';
import 'dart:io';

import 'package:absensi_ppkd/constants/endpoint.dart';
import 'package:absensi_ppkd/helper/shared_pref_helper.dart';
import 'package:absensi_ppkd/models/response_model.dart';
import 'package:absensi_ppkd/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<ResponseModel> postRegisterUser({
    required String username,
    required String password,
    required String email,
    required String gender,
    required String? profilePhoto,
    required int batchId,
    required int trainingId,
  }) async {
    try {
      Map<String, dynamic> registerMap = {
        "name": username,
        "email": email,
        "password": password,
        "jenis_kelamin": gender,
        "batch_id": batchId,
        "training_id": trainingId,
      };
      if (profilePhoto != null) {
        registerMap["profile_photo"] = profilePhoto;
      }
      final response = await http.post(
        Uri.parse(Endpoint.register),
        headers: {"Accept": "application/json", "Content-Type": "application/json"},
        body: jsonEncode(registerMap),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel.fromJson(
          json: jsonDecode(response.body),
          fromJsonT: (x) => UserModel.fromJson(x),
        );
      } else {
        throw Exception("Register Failed:  ${response.statusCode}");
      }
    } on SocketException catch (e) {
      throw Exception("Error Register Failed:  $e");
    }
  }

  static Future<ResponseModel<UserModel>> postLoginUser({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> loginMap = {"email": email, "password": password};
      final response = await http.post(
        Uri.parse(Endpoint.login),
        headers: {"Accept": "application/json", "Content-Type": "application/json"},
        body: jsonEncode(loginMap),
      );
      if (response.statusCode == 200 || response.statusCode == 404 || response.statusCode == 401) {
        return ResponseModel.fromJson(
          json: jsonDecode(response.body),
          fromJsonT: (x) => UserModel.fromJson(x),
        );
      } else {
        throw Exception("Login Failed: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      throw Exception("Error Login Failed:  $e");
    }
  }

  static Future<ResponseModel<User>> getProfile() async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        throw "Token not found, Please Re-login";
      }
      final response = await http.get(
        Uri.parse(Endpoint.profile),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 404 || response.statusCode == 401) {
        return ResponseModel.fromJson(
          json: jsonDecode(response.body),
          fromJsonT: (x) => User.fromJson(x),
        );
      } else {
        throw Exception("Get Profile Failed: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      throw Exception("Error Profile Failed:  $e");
    }
  }

  static Future<ResponseModel<User>> editProfileData({required String username}) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        throw "Token not found, Please Re-login";
      }
      final response = await http.put(
        Uri.parse(Endpoint.profile),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"name": username}),
      );
      if (response.statusCode == 200 || response.statusCode == 404 || response.statusCode == 401) {
        return ResponseModel.fromJson(
          json: jsonDecode(response.body),
          fromJsonT: (x) => User.fromJson(x),
        );
      } else {
        throw Exception("Edit Profile Data Failed: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      throw Exception("Error Profile Data Failed:  $e");
    }
  }

  static Future<ResponseModel<bool>> editProfilePicture({required String imageBase64}) async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token.isEmpty) {
        throw "Token not found, Please Re-login";
      }
      final response = await http.put(
        Uri.parse("${Endpoint.profile}/photo"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"profile_photo": imageBase64}),
      );
      if (response.statusCode == 200) {
        return ResponseModel<bool>(message: "Success", data: true);
      } else {
        throw Exception("Edit Profile Picture Failed: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      throw Exception("Error Profile Picture Failed:  $e");
    }
  }

  static Future<ResponseModel<bool>> postRequestOtp({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.forgotPassword),
        headers: {"Accept": "application/json", "Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return ResponseModel<bool>(message: "Success", data: true);
      } else {
        throw Exception("Request OTP Failed: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      throw Exception("Error Request OTP Failed:  $e");
    }
  }

  static Future<ResponseModel<bool>> postResetPassword({
    required String email,
    required String password,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.resetPassword),
        headers: {"Accept": "application/json", "Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp, "password": password}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return ResponseModel<bool>(
          message: "Success Reset Password, Please log in again",
          data: true,
        );
      } else {
        throw Exception("Change Password Failed: ${response.statusCode} \n\n${response.body}");
      }
    } on SocketException catch (e) {
      throw Exception("Error Change Password Failed:  $e");
    }
  }
}
