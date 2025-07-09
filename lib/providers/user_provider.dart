import 'package:absensi_ppkd/models/user_model.dart';
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
}
