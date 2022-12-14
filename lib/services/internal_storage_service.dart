import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class InternalDataState {
  final int count;

  const InternalDataState({required this.count});
}

@immutable
class InternalDatabaseNotifier extends StateNotifier<InternalDataState> {
  InternalDatabaseNotifier() : super(const InternalDataState(count: 0));

  Future<void> storeData(int count) async {
    state = InternalDataState(count: state.count + count);
  }
}

final pendingCounter =
    StateNotifierProvider<InternalDatabaseNotifier, InternalDataState>((ref) {
  return InternalDatabaseNotifier();
});
