import 'dart:convert';
import 'dart:io';
import 'package:absensi_ppkd/api/user_api.dart';
import 'package:absensi_ppkd/models/user_model.dart';
import 'package:absensi_ppkd/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = NotifierProvider<UserProvider, UserState>(() => UserProvider());

class UserState {
  final User? user;

  const UserState({this.user});

  UserState copyWith({User? user}) {
    return UserState(user: user ?? this.user);
  }
}

class UserProvider extends Notifier<UserState> {
  @override
  UserState build() => const UserState();

  Future<void> setUser({required User user}) async {
    state = state.copyWith(user: user);
  }

  Future<void> getUserProfile({required BuildContext context}) async {
    try {
      final res = await UserApi.getProfile();
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(context, errorList);
      } else if (res.data != null) {
        await setUser(
          user: User(
            name: res.data!.name,
            email: res.data!.email,
            jenisKelamin: res.data!.jenisKelamin,
            profilePhoto: res.data!.profilePhoto,
            updatedAt: res.data!.updatedAt,
            createdAt: res.data!.createdAt,
            id: res.data!.id,
            batch: res.data!.batch,
            training: res.data!.training,
          ),
        );
      } else {
        AppToast.showErrorToast(context, res.message);
      }
    } catch (e) {
      AppToast.showErrorToast(context, e.toString());
    }
  }

  Future<bool> updateUserProfile({
    required BuildContext context,
    required String username,
  }) async {
    try {
      final res = await UserApi.editProfileData(username: username);
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(context, errorList);
        return false;
      } else if (res.data != null) {
        return true;
      } else {
        AppToast.showErrorToast(context, res.message);
        return false;
      }
    } catch (e) {
      AppToast.showErrorToast(context, e.toString());
      return false;
    }
  }

  Future<bool> updateUserPicture({
    required BuildContext context,
    required File image,
  }) async {
    try {
      final res = await UserApi.editProfilePicture(imageBase64: base64Encode(image.readAsBytesSync()));
      if (res.errors != null) {
        final errorList = res.errors!.toList();
        AppToast.showErrorListToast(context, errorList);
        return false;
      } else if (res.data != null) {
        return true;
      } else {
        AppToast.showErrorToast(context, res.message);
        return false;
      }
    } catch (e) {
      AppToast.showErrorToast(context, e.toString());
      return false;
    }
  }
}
