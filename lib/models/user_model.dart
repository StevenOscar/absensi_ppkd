import 'package:absensi_ppkd/models/batch_model.dart';
import 'package:absensi_ppkd/models/training_model.dart';

class UserModel {
  String token;
  User user;
  dynamic profilePhotoUrl;

  UserModel({required this.token, required this.user, required this.profilePhotoUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json["token"],
    user: User.fromJson(json["user"]),
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
    "profile_photo_url": profilePhotoUrl,
  };
}

class User {
  String name;
  String email;
  int? batchId;
  int? trainingId;
  String? jenisKelamin;
  dynamic profilePhoto;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  Batch? batch;
  Training? training;

  User({
    required this.name,
    required this.email,
    this.batchId,
    this.trainingId,
    required this.jenisKelamin,
    required this.profilePhoto,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    this.batch,
    this.training,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    batchId: json['batch_id'] is int ? json['batch_id'] : int.tryParse(json['batch_id'].toString()),
    trainingId:
        json['training_id'] is int
            ? json['training_id']
            : int.tryParse(json['training_id'].toString()),
    jenisKelamin: json['jenis_kelamin'] == null ? null : json["jenis_kelamin"],
    profilePhoto: json['profile_photo'] == null ? null : json["profile_photo"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    batch: json['batch'] == null ? null : Batch.fromJson(json["batch"]),
    training: json['training'] == null ? null : Training.fromJson(json["training"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "batch_id": batchId,
    "training_id": trainingId,
    "jenis_kelamin": jenisKelamin,
    "profile_photo": profilePhoto,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "batch": batch?.toJson(),
    "training": training?.toJson(),
  };
}
