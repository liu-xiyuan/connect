import 'package:connect/common/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// app主题设置
class AppThemeStyle {
  // 调色板
  static Color green = ColorUtil.hex("#28CD41");
  static Color red = ColorUtil.hex("#FF3B30");
  static Color orange = ColorUtil.hex("#FF9500");
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color darkGrey = ColorUtil.hex("#2C2C2E");
  static Color clearGrey = ColorUtil.hex("#EBEBF5").withOpacity(.5);
  static Color blurGrey = ColorUtil.hex("#2C2C2E").withOpacity(.6);

  /// 主题
  static ThemeData appTheme = ThemeData(
    fontFamily: "Harmony",

    // useMaterial3: true,

    // 去除安卓样式中的水波纹
    platform: TargetPlatform.iOS,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    primaryColor: white,
    scaffoldBackgroundColor: black,

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
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // 字体样式
    textTheme: TextTheme(
      headline1: TextStyle(
        color: white,
        fontSize: 30,
        height: 1.1,
        fontWeight: FontWeight.bold,
      ),

      headline2: TextStyle(
        color: white,
        fontSize: 20,
        height: 1.1,
        fontWeight: FontWeight.bold,
      ),

      bodyText1: TextStyle(
        color: white,
        fontSize: 17,
        height: 1.1,
      ),

      // 副标题字体样式
      subtitle1: TextStyle(
        color: white,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        height: 1.1,
      ),

      subtitle2: TextStyle(
        color: white,
        fontSize: 10,
        height: 1.1,
        fontWeight: FontWeight.bold,
      ),

      caption: TextStyle(
        color: white,
        fontSize: 12,
        height: 1.6,
        fontWeight: FontWeight.bold,
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
