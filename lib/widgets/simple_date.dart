import 'package:connect/controller/home_controller.dart';
import 'package:connect/controller/services/ml_awareness_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// 日期组件
class SimpleDate extends GetView<HomeController> {
  const SimpleDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Time
        Obx(
          () => Text(
            controller.nowTime.value,
            style: TextStyle(
              fontSize: 130,
              letterSpacing: 10,
              fontWeight: FontWeight.bold,
              color: AppThemeStyle.white,
            ),
          ),
        ),
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date
              Text(
                controller.nowDate.value,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              // Weather
              FaIcon(
                MlAwarenessController.to.weatherIcon.value,
                color: AppThemeStyle.white,
                size: 14,
              ).marginOnly(left: 15, right: 2),
              Text(
                '${MlAwarenessController.to.temperatureC}°',
                style:
                    Theme.of(context).textTheme.subtitle2!.copyWith(height: .9),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
