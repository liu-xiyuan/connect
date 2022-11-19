import 'dart:developer';

import 'package:connect/controller/lab/shutdown_controller.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/face_verification_controller.dart';
import 'package:connect/controller/services/hide_camera_controller.dart';
import 'package:connect/controller/services/permission_controller.dart';
import 'package:connect/controller/services/speech_recognition_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/widgets/toolbox_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  static HomeController get to => Get.find();

  /// 背景图片x轴偏移量
  var imageOffestX = (-1.0).obs;

  /// 页面跳转时主页的偏移量
  var homePageOffestX = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    initControllers();
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
    Get.put(FaceVerificationController());
    Get.put(HideCameraController());
    Get.put(SpeechRecognitionController());
    Get.put(BluetoothController());
    Get.put(ShutdownController());
  }

  /// 显示工具箱列表
  void showToolboxBar() {
    Get.bottomSheet(
      const ToolboxBar(),
      barrierColor: Colors.transparent,
    );
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
