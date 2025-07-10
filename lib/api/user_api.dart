import 'dart:convert';

import 'package:absensi_ppkd/constants/endpoint.dart';
import 'package:absensi_ppkd/helper/shared_pref_helper.dart';
import 'package:absensi_ppkd/models/response_model.dart';
import 'package:absensi_ppkd/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<ResponseModel> createUser({
    required String username,
    required String password,
    required String email,
    required String gender,
    required String? profilePhoto,
    required int batchId,
    required int trainingId,
  }) async {
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
      print(response.body);
      print(
        ResponseModel.fromJson(
          json: jsonDecode(response.body),
          fromJsonT: (x) => UserModel.fromJson(x),
        ),
      );
      return ResponseModel.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => UserModel.fromJson(x),
      );
    } else {
      throw Exception("Register Failed");
    }
  }

  static Future<ResponseModel<UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> loginMap = {"email": email, "password": password};
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json", "Content-Type": "application/json"},
      body: jsonEncode(loginMap),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 404 || response.statusCode == 401) {
      return ResponseModel.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => UserModel.fromJson(x),
      );
    } else {
      throw Exception("Login Failed: ${response.statusCode}");
    }
  }

  static Future<ResponseModel<User>> getProfile() async {
    final token = await SharedPrefHelper.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.profile),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 404 || response.statusCode == 401) {
      return ResponseModel.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => User.fromJson(x),
      );
    } else {
      throw Exception("Get Profile Failed: ${response.statusCode}");
    }
  }

  static Future<ResponseModel<User>> editProfileData({required String username}) async {
    final token = await SharedPrefHelper.getToken();
    final response = await http.put(
      Uri.parse(Endpoint.profile),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"name": username}),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 404 || response.statusCode == 401) {
      return ResponseModel.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => User.fromJson(x),
      );
    } else {
      throw Exception("Edit Profile Data Failed: ${response.statusCode}");
    }
  }

  static Future<ResponseModel<bool>> editProfilePicture({required String imageBase64}) async {
    final token = await SharedPrefHelper.getToken();
    final response = await http.put(
      Uri.parse("${Endpoint.profile}/photo"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"profile_photo": imageBase64}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<bool>(message: "Success", data: true);
    } else {
      throw Exception("Edit Profile Picture Failed: ${response.statusCode}");
    }
  }
}
