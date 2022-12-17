import 'dart:async';
import 'dart:developer';

import 'package:connect/common/get_notification.dart';
import 'package:connect/common/permission_checker.dart';
import 'package:connect/model/weather_info.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:huawei_awareness/huawei_awareness.dart';
import 'package:power/power.dart';

/// 意识套件服务
class MlAwarenessController extends GetxController {
  static MlAwarenessController get to => Get.find();

  static const MethodChannel _c = MethodChannel('android.flutter/Awareness');

  /// 电池电量图标
  var batterLevelIcon = FontAwesomeIcons.batteryFull.obs;

  /// 电池电量图标颜色
  var batterLevelColor = AppThemeStyle.white.obs;

  /// 是否充电中
  var isCharging = false.obs;

  /// 电池更新计时器
  Timer? powerTimer;

  /// 日期类别 - 夜晚
  var isDayNight = false.obs;

  /// 体感温度
  var temperatureC = 18.obs;

  /// 天气图标
  var weatherIcon = FontAwesomeIcons.cloud.obs;

  /// 天气更新计时器
  Timer? weatherTimer;

  @override
  void onInit() {
    super.onInit();
    activeWeatherTimer();
    activePowerTimer();
    initBarrierListener();
  }

  void initBarrierListener() {
    addLightBarrier();
    addTimeTypeBarrier();
    AwarenessBarrierClient.onBarrierStatusStream.listen((e) {
      switch (e.barrierLabel) {
        case 'Time Night Barrier':
          isDayNight.value = e.presentStatus == 1 ? true : false;
          break;
        case 'Light Barrier':
          if (e.presentStatus == 0) {
            // closeScreen();
          } else {}
          break;
        default:
      }
      log("Barrier: ${e.barrierLabel} | ${e.presentStatus ?? -1}");
    });
  }

  /// 添加光线传感器Barrier
  void addLightBarrier() async {
    AwarenessBarrier lightBarrier = AmbientLightBarrier.above(
      barrierLabel: 'Light Barrier',
      minLightIntensity: 20,
    );

    await AwarenessBarrierClient.updateBarriers(barrier: lightBarrier);
  }

  /// 时间类别Barrier
  void addTimeTypeBarrier() async {
    if (await PermissionChecker.checkAwarenessPermissions()) {
      /// 夜晚 - 1
      AwarenessBarrier nightBarrier = TimeBarrier.inTimeCategory(
        barrierLabel: 'Time Night Barrier',
        inTimeCategory: TimeBarrier.categoryNight,
      );

      await AwarenessBarrierClient.updateBarriers(barrier: nightBarrier);
    }
  }

  /// 激活电池状态更新计时器
  Future<void> activePowerTimer() async {
    int level = (await Power.batteryLevel) as int;
    isCharging.value = await Power.isCharging;

    if (level > 90) {
      batterLevelIcon.value = FontAwesomeIcons.batteryFull;
      batterLevelColor.value = AppThemeStyle.white;
    } else if (level > 50 && level <= 90) {
      batterLevelIcon.value = FontAwesomeIcons.batteryThreeQuarters;
      batterLevelColor.value = AppThemeStyle.white;
    } else if (level > 20 && level <= 50) {
      batterLevelIcon.value = FontAwesomeIcons.batteryHalf;
      batterLevelColor.value = AppThemeStyle.orange;
    } else if (level >= 20 && level > 10) {
      batterLevelIcon.value = FontAwesomeIcons.batteryQuarter;
      batterLevelColor.value = AppThemeStyle.red;
    } else if (level <= 10) {
      batterLevelIcon.value = FontAwesomeIcons.batteryEmpty;
      batterLevelColor.value = AppThemeStyle.red;
    }

    if (isCharging.value) {
      batterLevelColor.value = AppThemeStyle.green;
    }

    // log('电池电量: $level | 充电状态: ${isCharging.value}');

    if (powerTimer?.isActive ?? false) return;

    powerTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => activePowerTimer(),
    );
  }

  /// 熄屏
  void closeScreen() async {
    // GetNotification.showCustomSnackbar('title', 'message');
    try {
      await _c.invokeMethod('closeScreen');
    } catch (e) {
      log(e.toString());
    }
  }

  /// 亮屏
  void openScreen() async {
    try {
      await _c.invokeMethod('openScreen');
    } catch (e) {
      log(e.toString());
    }
  }

  /// 激活天气信息更新计时器 - 每小时更新
  void activeWeatherTimer() async {
    WeatherResponse? res;

    if (await PermissionChecker.checkAwarenessPermissions()) {
      try {
        res = await AwarenessCaptureClient.getWeatherByDevice();
      } catch (e) {
        GetNotification.showToast(message: "Weather update error");
      }

      int nowHours = DateTime.now().hour;
      int weatherId = res?.hourlyWeather?[nowHours].weatherId ?? 0;

      temperatureC.value = res?.hourlyWeather?[nowHours].tempC ?? 0;

      weatherIcon.value = WeatherInfo.getWeatherIcon(
        weatherId,
        isDayNight.value,
      );

      log('天气标识: $weatherId | 体感温度: $temperatureC');

      if (weatherTimer?.isActive ?? false) return;

      weatherTimer = Timer.periodic(
        const Duration(hours: 1),
        (_) => activeWeatherTimer(),
      );
    }
  }

  /// 取消计时器
  void cancelTimer() {
    weatherTimer?.cancel();
    powerTimer?.cancel();
  }

  @override
  void onClose() {
    super.onClose();
    cancelTimer();
  }
}
