import 'package:connect/controller/home_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 日期组件
class SimpleDate extends GetView<HomeController> {
  const SimpleDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Time
        Obx(
          () => Text(
            controller.nowTime.value,
            style: TextStyle(
              fontSize: 120,
              letterSpacing: 10,
              fontWeight: FontWeight.bold,
              color: AppThemeStyle.white,
            ),
          ),
        ),

        /// Date
        Obx(
          () => Text(
            controller.nowDate.value,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}
