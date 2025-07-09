import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider = NotifierProvider<NavigationProvider, NavigationState>(() => NavigationProvider());

class NavigationState {
  final int currentPage;

  const NavigationState({this.currentPage = 0});

  NavigationState copyWith({int? currentPage}) {
    return NavigationState(currentPage: currentPage ?? this.currentPage);
  }
}

class NavigationProvider extends Notifier<NavigationState> {
  @override
  NavigationState build() => const NavigationState();

  Future<void> setPage({required int currentPage}) async {
    state = state.copyWith(currentPage: currentPage);
  }
}
