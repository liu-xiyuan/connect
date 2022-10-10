import 'package:connect/controller/home_controller.dart';
import 'package:connect/pages/about_page.dart';
import 'package:connect/pages/facial_expression_page.dart';
import 'package:connect/pages/gamepad_page.dart';
import 'package:connect/pages/home_page.dart';
import 'package:connect/pages/lab_page.dart';
import 'package:connect/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRouter {
  static Duration duration = const Duration(milliseconds: 300);

  static Transition transition = Transition.rightToLeft;

  static Curve curves = Curves.easeOut;

  static Map<String, dynamic> routesInfo = {
    '/': const HomePage(),
    '/settings': const SettingsPage(),
    '/about': const AboutPage(),
    '/gamepad': const GamepadPage(),
    '/lab': const LabPage(),
    '/expression': const FacialExpressionPage(),
  };

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

    if (routing.current == '/' || routing.isBottomSheet!) {
      HomeController.to.homePageOffestX.value = 0;
    } else if (routesInfo.containsKey(routing.current)) {
      HomeController.to.homePageOffestX.value = -(0.15);
    }
  }
}
