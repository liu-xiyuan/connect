import 'package:connect/common/get_notification.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  static PermissionController get to => Get.find();

  /// 检查面部识别所需权限
  Future<bool> checkFacePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();

    var cameraStatus = statuses[Permission.camera]!;
    var storageStatus = statuses[Permission.storage]!;

    if (cameraStatus.isGranted && storageStatus.isGranted) {
      return true;
    } else {
      GetNotification.showCustomSnackbar(
        "Missing Permissions ",
        "Please allow relevant permissions!",
        tipsIcon: FontAwesomeIcons.circleExclamation,
        tipsIconColor: AppThemeStyle.red,
      );
      return false;
    }
  }

  /// 检查语音识别所需权限
  Future<bool> checkSpeechPermissions() async {
    var speechStatus = await Permission.speech.request();

    if (speechStatus.isGranted) {
      return true;
    } else {
      GetNotification.showCustomSnackbar(
        "Missing Recording permission",
        "Please allow relevant permissions!",
        tipsIcon: FontAwesomeIcons.circleExclamation,
        tipsIconColor: AppThemeStyle.red,
      );
      return false;
    }
  }

  /// 检查蓝牙权限
  Future<bool> checkBluePermissions() async {
    var blueStatus = await Permission.bluetoothConnect.request();

    if (blueStatus.isGranted) {
      return true;
    } else {
      GetNotification.showCustomSnackbar(
        "Bluetooth connection failed",
        "Missing Bluetooth permissions !",
        tipsIcon: FontAwesomeIcons.circleExclamation,
        tipsIconColor: AppThemeStyle.red,
      );
      return false;
    }
  }
}
