import 'package:flutter/cupertino.dart';
import 'colors.dart';

CupertinoThemeData get theme {
  return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryGreen,
      textTheme: CupertinoTextThemeData(
          tabLabelTextStyle: TextStyle(
            fontFamily: "Fustat-Medium",
            fontSize: 12,
            color: AppColors.primaryGreen,
            letterSpacing: -0.5,
          ),
          textStyle: TextStyle(
            fontFamily: "Fustat",
            fontSize: 24,
          )));
}
