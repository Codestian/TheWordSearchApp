import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsThemeBrightnessProvider =
    NotifierProvider<SettingsThemeBrightnessValue, bool>(
        SettingsThemeBrightnessValue.new);

class SettingsThemeBrightnessValue extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setLight() {
    state = false;
  }

  void setDark() {
    state = true;
  }
}

final settingsThemeSeedColorProvider =
    NotifierProvider<SettingsThemeSeedColorValue, Color>(
        SettingsThemeSeedColorValue.new);

class SettingsThemeSeedColorValue extends Notifier<Color> {
  @override
  Color build() {
    return Colors.blue;
  }

  void setSeedColor(Color seedColor) {
    state = seedColor;
  }

}

