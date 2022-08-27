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
    with GetSingleTickerProviderStateMixin {
  static HomeController get to => Get.find();

  /// 背景图片x轴偏移量
  var imageOffestX = (-1.0).obs;

  /// 页面跳转时主页的偏移量
  var homePageOffestX = 0.0.obs;

  /// 主页背景图动画控制器
  late Animation<double> imageAnimation;
  late AnimationController imageController;

  @override
  void onInit() {
    super.onInit();
    initControllers();
    initAnimation();
  }

  /// 初始化控制器
  void initControllers() {
    Get.put(TcpServiceController());
    Get.put(PermissionController());
    Get.put(FaceVerificationController());
    Get.put(HideCameraController());
    Get.put(SpeechRecognitionController());
    Get.put(BluetoothController());
  }

  /// 初始化主页背景滚动动画
  void initAnimation() {
    imageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    imageAnimation = Tween<double>(begin: -1.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(imageController)
      ..addListener(() {
        imageOffestX.value = double.parse(
          imageAnimation.toString().split('➩')[3],
        );
      });
  }

  /// 根据ToolCardList的[CarouselSlider()]索引值播放动画
  ///
  /// 在CarouselSlider()的 onPageChanged属性中调用此方法
  void playAnimation(int index, int beforeIndex, int length) {
    // 判断向左还是向右移动
    if (beforeIndex < index) {
      // 向右
      // animateTo() 从当前值到目标值, 范围[0,1]
      imageController.animateTo(
        index * (1 / length),
        curve: Curves.easeOut,
      );
    } else {
      // 向左
      imageController.animateBack(
        index * (1 / length),
        curve: Curves.easeOut,
      );
    }
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
    imageController.dispose();
  }
}
