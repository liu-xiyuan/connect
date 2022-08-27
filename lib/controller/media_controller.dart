import 'dart:developer';

import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/text_field_controller.dart';
import 'package:connect/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MediaController extends GetxController {
  late SharedPreferences prefs;

  /// 静音切换
  var muteSwitch = false.obs;

  /// 音乐播放器启动路径
  var launchPath = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    initLaunchPath();
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
      confirmTextColor: Colors.black,
      confirmBorderColor: Colors.black,
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
