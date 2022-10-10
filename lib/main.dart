import 'package:connect/pages/app_router.dart';
import 'package:connect/pages/home_page.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //不加这个强制横/竖屏会报错
  SystemChrome.setPreferredOrientations([
    // 强制竖屏
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppRouter.getRoutes(),
      theme: AppThemeStyle.appTheme,
      routingCallback: (routing) => AppRouter.routingCallback(routing!),
      home: const HomePage(),
    );
  }
}
