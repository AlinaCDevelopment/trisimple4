import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class InternalDataState {
  final int count;

  const InternalDataState({required this.count});
}

@immutable
class InternalDatabaseNotifier extends StateNotifier<int> {
  InternalDatabaseNotifier() : super(0);

  Future<void> increment(int count) async {
    state = state + count;
  }
}

final pendingCounter =
    StateNotifierProvider<InternalDatabaseNotifier, int>((ref) {
  return InternalDatabaseNotifier();
});
