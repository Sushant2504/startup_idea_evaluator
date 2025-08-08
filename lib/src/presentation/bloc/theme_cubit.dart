import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'theme_mode_v1';
  final SharedPreferences prefs;
  ThemeCubit(this.prefs) : super(ThemeMode.system);

  void load() {
    final v = prefs.getString(_key);
    if (v == 'dark') emit(ThemeMode.dark);
    if (v == 'light') emit(ThemeMode.light);
  }

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    prefs.setString(_key, next == ThemeMode.dark ? 'dark' : 'light');
  }
}


