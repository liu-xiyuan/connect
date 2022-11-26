import 'dart:async';
import 'dart:developer';

import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/permission_controller.dart';
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

  /// 电池电量
  var batterLevel = 100.obs;

  /// 电池电量图标
  var batterLevelIcon = FontAwesomeIcons.batteryFull.obs;

  /// 电池电量图标颜色
  var batterLevelColor = AppThemeStyle.white.obs;

  /// 是否充电中
  var isCharging = false.obs;

  /// 电池更新计时器
  Timer? powerTimer;

  /// 日期类别 - 夜晚
  var isNight = false.obs;

  /// 体感温度
  var temperatureC = 18.obs;

  /// 天气图标
  var weatherIcon = FontAwesomeIcons.cloud.obs;

  /// 天气更新计时器
  Timer? weatherTimer;

  /// 天气标识图标组
  Map<String, Map> weatherMap = {
    'sun': {
      'id': [1, 2, 33, 34],
      'icon': FontAwesomeIcons.solidSun,
    },
    'cloud': {
      'id': [3, 4, 5, 6, 7, 8, 35, 36],
      'icon': FontAwesomeIcons.cloud,
    },
    'smog': {
      'id': [11, 38],
      'icon': FontAwesomeIcons.smog,
    },
    'cloud-showers-heavy': {
      'id': [12, 13, 39, 40],
      'icon': FontAwesomeIcons.cloudShowersHeavy,
    },
    'cloud-sun-rain': {
      'id': [14, 17],
      'icon': FontAwesomeIcons.cloudSunRain,
    },
    'cloud-bolt': {
      'id': [15, 16, 41, 42],
      'icon': FontAwesomeIcons.cloudBolt,
    },
    'cloud-rain': {
      'id': [18, 20, 26],
      'icon': FontAwesomeIcons.cloudRain,
    },
    'snow': {
      'id': [19, 21, 22, 23, 25, 29, 43, 44],
      'icon': FontAwesomeIcons.solidSnowflake,
    },
    'ice': {
      'id': [24],
      'icon': FontAwesomeIcons.icicles,
    },
    'hot': {
      'id': [30],
      'icon': FontAwesomeIcons.temperatureHigh,
    },
    'cold': {
      'id': [31],
      'icon': FontAwesomeIcons.temperatureLow,
    },
    'wind': {
      'id': [32],
      'icon': FontAwesomeIcons.wind,
    },
    'cloud-moon': {
      'id': [37],
      'icon': FontAwesomeIcons.cloudMoon,
    },
  };

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
          isNight.value = e.presentStatus == 1 ? true : false;
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
    if (await PermissionController.to.checkAwarenessPermissions()) {
      /// 夜晚 - 1
      AwarenessBarrier nightBarrier = TimeBarrier.inTimeCategory(
        barrierLabel: 'Time Night Barrier',
        inTimeCategory: TimeBarrier.categoryNight,
      );

      await AwarenessBarrierClient.updateBarriers(barrier: nightBarrier);
    }
  }

  /// 激活电池状态更新计时器
  void activePowerTimer() async {
    batterLevel.value = (await Power.batteryLevel) as int;
    isCharging.value = await Power.isCharging;

    if (batterLevel.value > 90) {
      batterLevelIcon.value = FontAwesomeIcons.batteryFull;
      batterLevelColor.value = AppThemeStyle.white;
    } else if (batterLevel.value > 50 && batterLevel.value <= 90) {
      batterLevelIcon.value = FontAwesomeIcons.batteryThreeQuarters;
      batterLevelColor.value = AppThemeStyle.white;
    } else if (batterLevel.value > 20 && batterLevel.value <= 50) {
      batterLevelIcon.value = FontAwesomeIcons.batteryHalf;
      batterLevelColor.value = AppThemeStyle.orange;
    } else if (batterLevel.value >= 20 && batterLevel.value > 10) {
      batterLevelIcon.value = FontAwesomeIcons.batteryQuarter;
      batterLevelColor.value = AppThemeStyle.red;
    } else if (batterLevel.value <= 10) {
      batterLevelIcon.value = FontAwesomeIcons.batteryEmpty;
      batterLevelColor.value = AppThemeStyle.red;
    }

    if (isCharging.value) {
      batterLevelColor.value = AppThemeStyle.green;
    }

    log('电池电量: ${batterLevel.value} | 充电状态: ${isCharging.value}');

    if (powerTimer?.isActive ?? false) {
      return;
    }
    powerTimer?.cancel();
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
    if (await PermissionController.to.checkAwarenessPermissions()) {
      try {
        res = await AwarenessCaptureClient.getWeatherByDevice();
      } catch (e) {
        GetNotification.showToast(message: "Weather update error");
      }

      temperatureC.value = res?.weatherSituation?.situation?.temperatureC ?? 0;

      int weatherId = res?.weatherSituation?.situation?.cnWeatherId ?? 0;

      weatherMap.forEach((key, value) {
        if (value['id'].contains(weatherId)) {
          weatherIcon.value = value['icon'];
        }
      });

      log('天气标识$weatherId | 体感温度$temperatureC');

      if (weatherTimer?.isActive ?? false) {
        return;
      }
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
