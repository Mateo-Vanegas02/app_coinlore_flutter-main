import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final ThemeMode themeMode;
  final String currency;
  final String locale;

  AppSettings({
    this.themeMode = ThemeMode.dark,
    this.currency = 'USD',
    this.locale = 'en',
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? currency,
    String? locale,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      locale: locale ?? this.locale,
    );
  }
}

final settingsProvider = StateProvider<AppSettings>((ref) {
  return AppSettings();
});

final themeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});

final currencyProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).currency;
});

final localeProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).locale;
});
