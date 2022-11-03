import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(Locale.fromSubtags(languageCode: 'pt'));

  void setLocale(String languageCode) =>
      state = Locale.fromSubtags(languageCode: languageCode);
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
