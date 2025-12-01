import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/local/hive_keys.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final box = Hive.box(HiveKeys.settingsBox);
    final saved = box.get(HiveKeys.themeModeKey) as String?;

    if (saved == 'light') {
      state = ThemeMode.light;
    } else if (saved == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final box = Hive.box(HiveKeys.settingsBox);

    final str = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';

    await box.put(HiveKeys.themeModeKey, str);
  }
}
