import 'dart:convert';

import 'package:absensi_ppkd/constants/endpoint.dart';
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
      throw Exception("Login Failed");
    }
  }
}
