import 'dart:developer';

import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/text_field_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/app_text_field.dart';

import 'package:connect/widgets/media_controller_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 蓝牙服务
class BluetoothController extends GetxController {
  static BluetoothController get to => Get.find();

  static const MethodChannel _c = MethodChannel("android.flutter/Bluetooth");

  late SharedPreferences prefs;

  RxString macAddress = ''.obs;

  var isConnected = false.obs; // 蓝牙是否已连接
  var isHidDevice = false.obs; // 是否注册为蓝牙HID设备

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    initChannelListen();
    initHidDevice();
  }

  /// 监听Android端发送的消息
  void initChannelListen() async {
    _c.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'blueStatusCall':
          blueStatusCall(call);
          break;
        case 'hidStatusCall':
          hidStatusCall(call);
          break;
        case 'test':
          log('AndroidChannel:[method:test | arguments:${call.arguments}]');
          break;
        default:
      }
    });
  }

  /// 将App注册成HID设备
  void initHidDevice() async {
    macAddress.value = prefs.getString('mac') ?? '34:7D:F6:56:C1:5F';
    if (!isHidDevice.value) {
      try {
        await _c.invokeMethod("initHidDevice");
      } catch (e) {
        GetNotification.showCustomSnackbar(
          'Bluetooth HID',
          'Device doesn\'t support Bluetooth HID',
          tipsIcon: FontAwesomeIcons.solidCircleXmark,
          tipsIconColor: AppThemeStyle.red,
        );
        log('InitHidDevice faild: [$e]');
      }
    }
  }

  /// 更新MAC地址
  void updateMacAddress() async {
    macAddress.value = TextFieldController.to.editController.text;

    await prefs.setString('mac', macAddress.value);
  }

  /// 显示MAC地址编辑框
  void showEditSheet({
    bool isSavedConnect = false, // 是否保存并连接
  }) {
    GetNotification.showCustomBottomSheet(
      title: 'Set MAC address',
      confirmTitle: isSavedConnect ? "save & connect" : "save",
      confirmBorderColor: AppThemeStyle.white,
      confirmOnTap: () {
        updateMacAddress();
        Get.back();
        if (isSavedConnect) {
          connect();
        }
      },
      cancelOnTap: () => Get.back(),
      children: [
        AppTextField(
          initText: macAddress.value,
          hintText: 'Input: 35:7G:F4:77:C2:9F',
        ).marginSymmetric(vertical: 20),
      ],
    );
  }

  /// 通过蓝牙与电脑连接
  void connect() async {
    if (isHidDevice.value && !isConnected.value) {
      try {
        await _c.invokeMethod("connect", macAddress.value);
      } catch (e) {
        log('Bluetooth connect faild: [$e]');
      }
    } else {
      initHidDevice();
    }
  }

  /// 检查蓝牙是否连接
  bool checkBluetooth() {
    if (!isConnected.value) {
      GetNotification.showCustomSnackbar(
        'Bluetooth disconnected',
        'Check Mac address and Bluetooth devices',
        tipsIcon: FontAwesomeIcons.bluetooth,
        tipsIconColor: AppThemeStyle.red,
      );
    }
    return isConnected.value;
  }

  /// 蓝牙HID键盘按压操作
  /// [.sendKeyWithRelease("a")]
  Future sendKeyWithRelease(String key) async {
    if (checkBluetooth()) {
      await _c.invokeMethod("sendKeyWithRelease", key);
    }
  }

  /// 按下对应键
  Future sendKey(String key) async {
    if (checkBluetooth()) {
      await _c.invokeMethod("sendKey", key);
    }
  }

  /// 松开对应键
  Future sendKeyRelease() async {
    if (checkBluetooth()) {
      await _c.invokeMethod("sendKeyRelease");
    }
  }

  /// 蓝牙HID媒体控制
  Future mediaControl(MediaControl mediaControl) async {
    if (checkBluetooth()) {
      await _c.invokeMethod(
        "mediaControl",
        mediaControl.toString(),
      );
    }
  }

  /// 显示媒体控制页面
  void showMediaInterface() {
    Get.bottomSheet(
      const MediaInterface(),
      enableDrag: false,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 150),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
    );
  }

  void blueStatusCall(MethodCall call) {
    isConnected.value = call.arguments;
    // if (!isConnected.value) {
    //   GetNotification.showSnackbar(
    //     'Bluetooth disconnected',
    //     'Check Mac address and Bluetooth devices',
    //     tipsIcon: FontAwesomeIcons.bluetooth,
    //     tipsIconColor: AppThemeStyle.red,
    //     isCleanQueue: false,
    //   );
    // }
    log('蓝牙连接: ${isConnected.value}');
  }

  void hidStatusCall(MethodCall call) {
    isHidDevice.value = call.arguments;
    if (isHidDevice.value) {
      connect();
    }
    log('设备HID注册: ${isHidDevice.value}');
  }
}

/// 蓝牙HID媒体控制
enum MediaControl {
  /// 静音
  mute,

  /// 音量+
  volumeUp,

  /// 音量-
  volumeDown,

  /// 下一首
  nextTrack,

  /// 上一首
  previousTrack,

  /// 播放/暂停
  playOrPause,
}
