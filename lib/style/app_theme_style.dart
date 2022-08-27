import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// app主题设置
class AppThemeStyle {
  /// 主题
  static ThemeData appTheme = ThemeData(
    fontFamily: "Harmony",

    // useMaterial3: true,

    // 去除安卓样式中的水波纹
    platform: TargetPlatform.iOS,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    // AppBar样式
    appBarTheme: const AppBarTheme(
      // 手机状态栏样式
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark, // 图标颜色
        statusBarColor: Colors.transparent, // 背景颜色
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        height: 1.1,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    // 字体样式
    textTheme: const TextTheme(
      // 页面标题
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      // 大号字体样式
      headline2: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      // 基本字体样式
      bodyText1: TextStyle(
        fontSize: 16,
      ),

      // 副标题字体样式
      subtitle1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        height: 1.1,
      ),
    ),

    // Button样式
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
  );
}
