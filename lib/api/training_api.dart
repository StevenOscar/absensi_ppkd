import 'dart:convert';
import 'dart:io';

import 'package:absensi_ppkd/constants/endpoint.dart';
import 'package:absensi_ppkd/models/batch_model.dart';
import 'package:absensi_ppkd/models/response_model.dart';
import 'package:absensi_ppkd/models/training_model.dart';
import 'package:http/http.dart' as http;

class TrainingApi {
  static Future<ResponseModel<List<Batch>>> getAllBatches() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoint.batches),
        headers: {"Accept": "application/json"},
      );
      if (response.statusCode == 200) {
        return ResponseModel.listFromJson<Batch>(
          json: jsonDecode(response.body),
          fromJsonT: (x) => Batch.fromJson(x),
        );
      } else {
        throw Exception("Error Fetch Batches: ${response.statusCode}\n${jsonDecode(response.body)["message"]}",
        );
      }
    } on SocketException catch (e) {
      throw Exception("Error Check Out:  $e");
    }
  }

  static Future<ResponseModel<List<Training>>> getAllTraining() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoint.trainings),
        headers: {"Accept": "application/json"},
      );
      if (response.statusCode == 200) {
        return ResponseModel.listFromJson<Training>(
          json: jsonDecode(response.body),
          fromJsonT: (x) => Training.fromJson(x),
        );
      } else {
        throw Exception("Error Fetch Trainings:  ${response.statusCode} \n${jsonDecode(response.body)["message"]}");
      }
    } on SocketException catch (e) {
      throw Exception("Error Check Out:  $e");
    }
  }
}
