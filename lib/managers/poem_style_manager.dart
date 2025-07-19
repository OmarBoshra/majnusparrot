import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majnusparrot/constants/my_colors.dart';

class PoemStyleManager extends StateNotifier<MyColorScheme> {
  PoemStyleManager(this.ref, [String themeMode = 'Light'])
      : super(_getColorScheme(themeMode));

  final Ref ref;

  static MyColorScheme _getColorScheme(String themeMode) {
    switch (themeMode) {
      case 'Dark':
        return MyColorScheme.fromMap({
          'appBarColor': Colors.black87,
          'switchOn': MyColors.gold,
          'switchOff': MyColors.magenta,
          'editorBackground': Colors.grey[850]!,
          'recommendationBackground': Colors.grey[900]!,
          'textFieldBackground': Colors.grey[800]!,
          'headerTextColor': Colors.white,
          'bodyTextColor': Colors.white70,
        }, themeMode);
      case 'Light':
      default:
        return MyColorScheme.fromMap({
          'appBarColor': Colors.green,
          'switchOn': MyColors.royalPurple,
          'switchOff': MyColors.navyBlue,
          'editorBackground': Colors.green[100]!,
          'recommendationBackground': Colors.green[100]!,
          'textFieldBackground': Colors.yellow,
          'headerTextColor': Colors.blue,
          'bodyTextColor': Colors.black87,
        }, themeMode);
    }
  }

  void updateTheme(String themeMode) {
    state = _getColorScheme(themeMode);
  }
}

class MyColorScheme {
  final String themeType;
  final Color appBarColor;
  final Color switchOn;
  final Color switchOff;
  final Color editorBackground;
  final Color recommendationBackground;
  final Color textFieldBackground;
  final Color headerTextColor;
  final Color bodyTextColor;

  MyColorScheme({
    required this.themeType,
    required this.appBarColor,
    required this.switchOn,
    required this.switchOff,
    required this.editorBackground,
    required this.recommendationBackground,
    required this.textFieldBackground,
    required this.headerTextColor,
    required this.bodyTextColor,
  });

  MyColorScheme.fromMap(Map<String, Color> map, this.themeType)
      : appBarColor = map['appBarColor']!,
        switchOn = map['switchOn']!,
        switchOff = map['switchOff']!,
        editorBackground = map['editorBackground']!,
        recommendationBackground = map['recommendationBackground']!,
        textFieldBackground = map['textFieldBackground']!,
        headerTextColor = map['headerTextColor']!,
        bodyTextColor = map['bodyTextColor']!;
}
