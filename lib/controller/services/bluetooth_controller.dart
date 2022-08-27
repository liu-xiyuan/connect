import 'dart:developer';

import 'package:connect/common/get_notification.dart';
import 'package:connect/style/color_palette.dart';
import 'package:connect/widgets/media_controller_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothController extends GetxController {
  static BluetoothController get to => Get.find();

  late SharedPreferences prefs;

  // 与Android通信的信道名称
  static const MethodChannel _androidChannel =
      MethodChannel("android.flutter/Bluetooth");

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
    _androidChannel.setMethodCallHandler((call) async {
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
    if (!isHidDevice.value) {
      try {
        await _androidChannel.invokeMethod("initHidDevice");
      } catch (e) {
        GetNotification.showSnackbar(
          'Bluetooth HID',
          'Device doesn\'t support Bluetooth HID',
          tipsIcon: FontAwesomeIcons.solidCircleXmark,
          tipsIconColor: ColorPalette.red,
        );
        log('InitHidDevice faild: [$e]');
      }
    }
  }

  /// 通过蓝牙与电脑连接(使用之前需手动配对)
  void connect() async {
    String macAddress = prefs.getString('mac') ?? "34:7D:F6:56:C1:5F";

    if (isHidDevice.value && !isConnected.value) {
      try {
        await _androidChannel.invokeMethod("connect", macAddress);
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
      GetNotification.showSnackbar(
        'Bluetooth disconnected',
        'Check Mac address and Bluetooth devices',
        tipsIcon: FontAwesomeIcons.bluetooth,
        tipsIconColor: ColorPalette.red,
      );
    }
    return isConnected.value;
  }

  /// 蓝牙HID键盘按压操作
  /// [.sendKeyWithRelease("a")]
  Future sendKeyWithRelease(String key) async {
    if (checkBluetooth()) {
      await _androidChannel.invokeMethod("sendKey", key);
    }
  }

  /// 蓝牙HID媒体控制
  Future mediaControl(MediaControl mediaControl) async {
    if (checkBluetooth()) {
      await _androidChannel.invokeMethod(
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
      enterBottomSheetDuration: const Duration(),
      exitBottomSheetDuration: const Duration(),
    );
  }

  void blueStatusCall(MethodCall call) {
    isConnected.value = call.arguments;
    if (!isConnected.value) {
      GetNotification.showSnackbar(
        'Bluetooth disconnected',
        'Check Mac address and Bluetooth devices',
        tipsIcon: FontAwesomeIcons.bluetooth,
        tipsIconColor: ColorPalette.red,
        isCleanQueue: false,
      );
    }
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
