import 'dart:developer';
import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/home_controller.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/text_field_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/app_text_field.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MediaController extends GetxController {
  static MediaController get to => Get.find();
  late SharedPreferences prefs;

  /// 是否按下音量释放键
  var isVloumnRelease = true;

  /// 静音切换
  var muteSwitch = false.obs;

  /// 音乐播放器启动路径
  var launchPath = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    initLaunchPath();
    initScaleListener();
  }

  /// 初始化双指缩放手势监听
  void initScaleListener() {
    ever(
      HomeController.to.scaleVerticalScale,
      (value) => updateVolumn(value as double),
      condition: () =>
          HomeController.to.scalePointerCount.value == 2 &&
          BluetoothController.to.isConnected.value,
    );
  }

  /// 缩放手势音量调节
  void updateVolumn(double value) {
    if (value > 1.0 && isVloumnRelease) {
      BluetoothController.to.mediaControl(MediaControl.volumeUp);
      isVloumnRelease = false;
      log('MediaControl.volumeUp');
    } else if (value < 1.0 && isVloumnRelease) {
      BluetoothController.to.mediaControl(MediaControl.volumeDown);
      isVloumnRelease = false;
      log('MediaControl.volumeDown');
    } else if (value == 1.0) {
      releaseVolumn();
    }
  }

  /// 释放音量控制键
  void releaseVolumn() {
    if (BluetoothController.to.isConnected.value) {
      BluetoothController.to.mediaControl(MediaControl.release);
      isVloumnRelease = true;
      log('MediaControl.release');
    }
  }

  /// 初始化音乐播放器启动路径
  void initLaunchPath() {
    launchPath.value = prefs.getString('musicPlayerPath') ??
        'D:\\App\\CloudMusic\\cloudmusic.exe';
  }

  /// 设置音乐播放器启动路径
  void updataLaunchPath() async {
    GetNotification.showCustomBottomSheet(
      title: 'Set Launch Path',
      confirmBorderColor: AppThemeStyle.clearGrey,
      confirmOnTap: () async {
        String path = TextFieldController.to.editController.text;
        launchPath.value = path;
        await prefs.setString('musicPlayerPath', path);
        Get.back();
      },
      cancelOnTap: () => Get.back(),
      children: [
        AppTextField(
          initText: launchPath.value,
          hintText: 'Input: D:\\xx\\xx.exe',
        ).marginSymmetric(vertical: 20),
      ],
    );
  }
}
