import 'package:connect/common/get_notification.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限检查服务
class PermissionController extends GetxController {
  static PermissionController get to => Get.find();

  void showNotification() {
    GetNotification.showCustomSnackbar(
      "Missing Permissions ",
      "Please allow relevant permissions!",
      tipsIcon: FontAwesomeIcons.circleExclamation,
      tipsIconColor: AppThemeStyle.red,
    );
  }

  /// 检查面部识别所需权限
  Future<bool> checkFacePermissions() async {
    bool res = false;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();

    statuses.forEach((key, value) {
      res = value.isGranted ? true : false;
    });

    if (!res) {
      showNotification();
    }
    return res;
  }

  /// 检查语音识别所需权限
  Future<bool> checkSpeechPermissions() async {
    var speechStatus = await Permission.speech.request();

    if (speechStatus.isGranted) {
      return true;
    } else {
      showNotification();
      return false;
    }
  }

  /// 检查蓝牙功能所需权限
  Future<bool> checkBluePermissions() async {
    var blueStatus = await Permission.bluetoothConnect.request();

    if (blueStatus.isGranted) {
      return true;
    } else {
      showNotification();
      return false;
    }
  }

  /// 检查Awareness所需权限
  Future<bool> checkAwarenessPermissions() async {
    bool res = false;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();

    statuses.forEach((key, value) {
      res = value.isGranted ? true : false;
    });

    if (!res) {
      showNotification();
    }

    return res;
  }
}
