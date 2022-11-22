import 'dart:async';
import 'dart:developer';

import 'package:connect/controller/lab/shutdown_controller.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/ml_face_controller.dart';
import 'package:connect/controller/services/hide_camera_controller.dart';
import 'package:connect/controller/services/ml_translation_controller.dart';
import 'package:connect/controller/services/permission_controller.dart';
import 'package:connect/controller/services/ml_speech_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  static HomeController get to => Get.find();

  /// 页面跳转时主页的偏移量
  var homePageOffestX = 0.0.obs;

  /// 缩放手势时的手指数
  var scalePointerCount = 0.obs;

  /// 缩放手势的Y轴缩放比例, 该值必须大于或等于0
  var scaleVerticalScale = 0.0.obs;

  /// 长按拖动手势的X轴偏移量
  double longPressMoveOffestX = 0.0;

  /// 长按拖动手势的Y轴偏移量
  double longPressMoveOffestY = 0.0;

  /// 左右滑动的偏移量
  var offestX = .0;

  /// 上下滑动的偏移量
  var offestY = .0;

  var nowTime = "".obs;

  var nowDate = "".obs;

  var monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  var weekList = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];

  @override
  void onInit() {
    super.onInit();
    initControllers();
    updateTime();
    WidgetsBinding.instance.addObserver(this); // 监听应用程序生命周期状态
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        BluetoothController.to.initHidDevice();
        log("App进入前台: $state");
        break;
      case AppLifecycleState.paused:
        log("App进入后台: $state");
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  /// 初始化控制器
  void initControllers() {
    Get.put(TcpServiceController());
    Get.put(PermissionController());
    Get.put(HideCameraController());
    Get.put(MlFaceController());
    Get.put(MlSpeechController());
    Get.put(MlTranslatorController());
    Get.put(BluetoothController());
    Get.put(ShutdownController());
  }

  /// 更新时间
  void updateTime() {
    var date = DateTime.now();
    nowTime.value = "${format(date.hour)}:${format(date.minute)}";
    nowDate.value =
        "${monthList[date.month - 1]} ${format(date.day)}, ${date.year}  ${weekList[date.weekday - 1]}";

    Timer(
      const Duration(seconds: 1) - Duration(milliseconds: date.millisecond),
      updateTime,
    );
  }

  /// 格式化时间按
  String format(Object time) {
    return time.toString().padLeft(2, '0');
  }

  /// -----------------------------
  /// 滑动手势 ！
  /// -----------------------------

  /// 水平滑动
  void onHorizontalDragUpdate(DragUpdateDetails e) {
    offestX = e.delta.dx;
  }

  void onHorizontalDragEnd() {
    // offset > a :右滑 | offset < a :左滑
    if (offestX > 5) {
      //
    } else if (offestX < -5) {
      Get.toNamed('/tool');
    }
  }

  /// 垂直滑动
  void onVerticalDragUpdate(DragUpdateDetails e) {
    offestY = e.delta.dy + .5;
  }

  void onVerticalDragEnd() {
    // offset > 0 :下滑
    if (offestY > 0) {
      //
    } else if (offestY < 0) {
      //
    }
  }

  /// -----------------------------
  /// 长按手势 ！
  /// -----------------------------

  /// 长按滑动
  void onLongPressStart() {
    Vibrate.feedback(FeedbackType.success); // 震动提示
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails e) {
    longPressMoveOffestX = e.localOffsetFromOrigin.dx;
    longPressMoveOffestY = e.localOffsetFromOrigin.dy;
  }

  void onLongPressEnd() {
    log(longPressMoveOffestY.toString());
    if (longPressMoveOffestX > 120) {
      // 长按并向右轻扫
      log("LongPress-right");
    } else if (longPressMoveOffestX < -120) {
      // 长按并向左轻扫
      log("LongPress-left");
    } else if (longPressMoveOffestY > 120) {
      // 长按并向下轻扫
      log("LongPress-down");
      MlFaceController.to.showFaceInterface();
    } else if (longPressMoveOffestY < -75) {
      // 长按并向上轻扫
      log("LongPress-up");
      MlSpeechController.to.showSpeechInterface();
    }

    longPressMoveOffestX = 0;
    longPressMoveOffestY = 0;
  }

  /// -----------------------------
  /// 缩放手势 ！
  /// -----------------------------

  void onScaleUpdate(ScaleUpdateDetails e) {
    scalePointerCount.value = e.pointerCount;
    scaleVerticalScale.value = double.parse(e.verticalScale.toStringAsFixed(1));
    // log('pointerCount: $scalePointerCount|verticalScale: $scaleVerticalScale|');
  }

  void onScaleEnd() {
    if (scalePointerCount.value == 2 && scaleVerticalScale < 0.5) {
      // 双指捏合
      log('ZOOM_IN');
    } else if (scalePointerCount.value == 2 && scaleVerticalScale > 1.5) {
      // 双指张开
      log('ZOOM_OUT');
    } else if (scalePointerCount.value == 3 && scaleVerticalScale < .5) {
      // 三指捏合
    } else if (scalePointerCount.value == 3 && scaleVerticalScale > 1.5) {
      /// 三指张开
    }
    // log('${scalePointerCount} | ${scaleVerticalScale}');
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
