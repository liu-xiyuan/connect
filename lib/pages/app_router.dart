import 'package:connect/controller/home_controller.dart';
import 'package:connect/pages/about_page.dart';
import 'package:connect/pages/facial_expression_page.dart';
import 'package:connect/pages/home_page.dart';
import 'package:connect/pages/lab_page.dart';
import 'package:connect/pages/settings_page.dart';
import 'package:connect/pages/tool_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppRouter {
  static Duration duration = const Duration(milliseconds: 250);

  static Transition transition = Transition.rightToLeft;

  static Curve curves = Curves.easeOut;

  static Map<String, dynamic> routesInfo = {
    '/': const HomePage(),
    '/settings': const SettingsPage(),
    '/about': const AboutPage(),
    '/lab': const LabPage(),
    '/expression': const FacialExpressionPage(),
    '/tool': const ToolPage(),
  };

  static List verticalPages = ["/about", "/settings"];

  static List<GetPage> getRoutes() {
    List<GetPage> routes = [];
    routesInfo.forEach((key, value) {
      routes.add(
        GetPage(
          name: key,
          page: () => value,
          transitionDuration: duration,
          transition: transition,
          curve: curves,
        ),
      );
    });
    return routes;
  }

  static routingCallback(Routing routing) {
    Get.put(HomeController());
    var page = routing.current;

    if (page == '/' || routing.isBottomSheet!) {
      HomeController.to.homePageOffestX.value = 0;
    } else if (routesInfo.containsKey(page)) {
      HomeController.to.homePageOffestX.value = -(0.15);
    }

    if (verticalPages.contains(page)) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }
}
