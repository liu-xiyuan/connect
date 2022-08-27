import 'dart:developer';
import 'dart:io';
import 'package:connect/common/color_util.dart';
import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/hide_camera_controller.dart';
import 'package:connect/controller/services/permission_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/style/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:huawei_ml_body/huawei_ml_body.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// HMS面部识别控制器
class FaceVerificationController extends GetxController {
  static FaceVerificationController get to => Get.find();

  /// 面部模板的本地路径 (手机图片存储路径)
  late String faceTemplateLocalPath;

  /// 相机拍摄的面部图像本地路径
  late String faceLocalPath;

  /// 电脑是否位于锁屏界面
  bool isLockScreen = false;

  @override
  void onInit() {
    super.onInit();
    initFaceTemplate();
  }

  /// 初始化面部模板
  void initFaceTemplate() async {
    // 获取本地目录
    Directory appdocDir = await getApplicationDocumentsDirectory();

    // 初始化图片路径
    faceTemplateLocalPath = '${appdocDir.path}/face_template.jpg';
    faceLocalPath = '${appdocDir.path}/face_use.jpg';

    // 读取assets文件夹中的模板图片
    ByteData imgTemp = await DefaultAssetBundle.of(Get.context!)
        .load('assets/images/face_template.jpg');

    // 将模板图片保存至本地
    File(faceTemplateLocalPath).writeAsBytes(imgTemp.buffer.asUint8List());
  }

  /// 面部识别
  ///
  /// 该服务识别并提取模板中面部的关键特征，将特征与输入图像中的面部特征进行比较，然后根据相似度判断两张面部是否属于同一个人。
  void startFaceVerification() async {
    // 创建面部验证分析器。
    final analyzer = MLFaceVerificationAnalyzer();

    /// 面部对比相似度
    double similarity = 0.0;

    // // 为面部验证创建模板面部。
    // ignore: unused_local_variable
    List<MLFaceTemplateResult> templateResult =
        await analyzer.setTemplateFace(faceTemplateLocalPath, 0);

    // 根据模板面部同步进行面部验证。
    List<MLFaceVerificationResult> results =
        await analyzer.analyseFrame(faceLocalPath);

    // 验证后,停止分析器
    bool analyzerStatus = await analyzer.stop();

    /// 获取验证结果的面部对比相似度信息
    if (results.isNotEmpty) {
      similarity = results[0].similarity;

      log('面部对比相似度: ${similarity.toStringAsFixed(3)}');
    }

    if (analyzerStatus) {
      // 相似度大于0.72则解锁成功
      if (similarity > 0.72) {
        // 检查电脑是否处于锁屏状态
        TcpServiceController.to.sendData(
          TcpCommands.otherAction,
          OtherAction.checkLockScreen,
        );

        // 显示面部识别成功提示
        GetNotification.showSnackbar(
          'Face Unlock',
          'Face recognition success',
          tipsIcon: FontAwesomeIcons.solidCircleCheck,
          tipsIconColor: ColorPalette.green,
        );
      } else {
        GetNotification.showSnackbar(
          "Face Unlock",
          "Face recognition failure!",
          tipsIcon: FontAwesomeIcons.solidFaceMeh,
          tipsIconColor: ColorPalette.red,
        );
      }
    }
  }

  /// 解锁电脑
  void unlockComputer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pwd = prefs.getString('lockPwd');

    if (isLockScreen) {
      if (pwd != null) {
        List pwdList = pwd.split('');
        if (BluetoothController.to.isConnected.value) {
          // 显示密码输入框
          BluetoothController.to.sendKeyWithRelease('ESC');

          // 等待500ms后输入密码
          Future.delayed(const Duration(milliseconds: 500), () {
            for (var e in pwdList) {
              BluetoothController.to.sendKeyWithRelease('$e');
            }
            BluetoothController.to.sendKeyWithRelease('ENTER');
          });
        } else {
          GetNotification.showSnackbar(
            'Bluetooth disconnected',
            'Check Mac address and Bluetooth devices',
            tipsIcon: FontAwesomeIcons.bluetooth,
            tipsIconColor: ColorPalette.red,
          );
        }
      } else {
        GetNotification.showSnackbar(
          'Face Unlock',
          'Please set lockScreen password',
          tipsIcon: FontAwesomeIcons.key,
          tipsIconColor: ColorPalette.grey,
        );
      }
    }
  }

  /// 显示人脸解锁界面
  Future<void> showFaceInterface() async {
    // 检查是否开启相关权限
    if (await PermissionController.to.checkFacePermissions()) {
      Get.closeCurrentSnackbar();
      Get.snackbar(
        '',
        '',
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 7),
        animationDuration: const Duration(milliseconds: 500),
        reverseAnimationCurve: const Threshold(0),
        overlayBlur: 10,
        isDismissible: false,
        titleText: const Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Face recognition in progress ...",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ).marginOnly(bottom: 15, top: 30),
        messageText: Center(
          child: SpinKitDoubleBounce(
            color: ColorUtil.hex("#3fd4f6"),
            duration: const Duration(seconds: 3),
            size: 50,
          ),
        ),

        /// sanckbar状态监听
        snackbarStatus: (status) {
          switch (status) {
            case SnackbarStatus.OPEN:
              {
                HideCameraController.to.openCamera();
              }
              break;
            default:
          }
        },
      );
    }
  }
}
