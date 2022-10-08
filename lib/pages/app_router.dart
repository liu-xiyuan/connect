import 'package:connect/controller/home_controller.dart';
import 'package:connect/pages/about_page.dart';
import 'package:connect/pages/gamepad_page.dart';
import 'package:connect/pages/home_page.dart';
import 'package:connect/pages/settings_page.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class AppRouter {
  static Duration duration = const Duration(milliseconds: 300);

  static Transition transition = Transition.rightToLeft;

  static Curve curves = Curves.easeOut;

  static List<String> routesName = ['/', '/settings', '/about', '/gamepad'];

  static List<GetPage> routes = [
    GetPage(
      name: '/',
      page: () => const HomePage(),
      transitionDuration: duration,
      transition: transition,
      curve: curves,
    ),
    GetPage(
      name: '/settings',
      page: () => const SettingsPage(),
      transitionDuration: duration,
      transition: transition,
      curve: curves,
    ),
    GetPage(
      name: '/about',
      page: () => const AboutPage(),
      transitionDuration: duration,
      transition: transition,
      curve: curves,
    ),
    GetPage(
      name: '/gamepad',
      page: () => const GamepadPage(),
      transitionDuration: duration,
      transition: transition,
      curve: curves,
    )
  ];

  /// 监听页面跳转事件。
  static routingCallback(Routing routing) {
    Get.put(HomeController());

    if (routing.current == '/') {
      HomeController.to.homePageOffestX.value = 0;
    } else if (routesName.contains(routing.current)) {
      HomeController.to.homePageOffestX.value = -(0.15);
    }
  }
}
