import 'dart:developer';
import 'dart:io';
import 'package:connect/common/color_util.dart';
import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/hide_camera_controller.dart';
import 'package:connect/common/permission_checker.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/controller/text_field_controller.dart';
import 'package:connect/model/tcp_call.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:huawei_ml_body/huawei_ml_body.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FaceVerificationResult { success, failure, noFace }

/// 面部识别服务
class MlFaceController extends GetxController {
  static MlFaceController get to => Get.find();

  late SharedPreferences prefs;

  // 创建面部验证分析器。
  final analyzer = MLFaceVerificationAnalyzer();

  /// 面部模板的本地路径 (手机图片存储路径)
  late String faceTemplateLocalPath;

  /// 相机拍摄的面部图像本地路径
  late String faceLocalPath;

  /// 电脑是否位于锁屏界面
  bool isLockScreen = false;

  @override
  void onInit() async {
    super.onInit();
    initFaceTemplate();
    prefs = await SharedPreferences.getInstance();
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
  /// 该服务识别并提取模板中面部的关键特征，将特征与输入图像中的面部特征进行比较
  /// 然后根据置信度判断两张面部是否属于同一个人。
  void startFaceVerification() async {
    /// 面部对比置信度
    double similarity = 0.0;

    /// 为面部验证创建模板面部。
    analyzer.setTemplateFace(faceTemplateLocalPath, 0);

    // 根据模板面部同步进行面部验证。
    List results = await analyzer.analyseFrame(faceLocalPath);

    /// 获取验证结果的面部对比置信度信息
    if (results.isNotEmpty) {
      similarity = results[0].similarity;

      log('面部对比置信度: ${similarity.toStringAsFixed(3)}');
    }

    // 置信度大于0.72则解锁成功
    if (similarity > 0.72) {
      // 显示面部识别成功提示
      showResult(FaceVerificationResult.success);
      // 检查电脑是否处于锁屏状态
      TcpServiceController.to.sendData(
        TcpCommands.otherAction,
        OtherAction.checkLockScreen,
      );
    } else {
      showResult(FaceVerificationResult.failure);
    }

    // 验证后,停止分析器
    await analyzer.stop();
  }

  /// 解锁电脑
  void unlockComputer() async {
    String pwd = prefs.getString('lockPwd') ?? '';

    if (isLockScreen) {
      if (pwd.isNotEmpty) {
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
          GetNotification.showCustomSnackbar(
            'Bluetooth disconnected',
            'Check Mac address and Bluetooth devices',
            tipsIcon: FontAwesomeIcons.bluetooth,
            tipsIconColor: AppThemeStyle.red,
          );
        }
      } else {
        GetNotification.showCustomSnackbar(
          'Face Unlock',
          'Please set lockScreen password',
          tipsIcon: FontAwesomeIcons.key,
          tipsIconColor: AppThemeStyle.clearGrey,
        );
      }
    }
  }

  /// 显示人脸解锁界面
  Future<void> showFaceInterface() async {
    // 检查是否开启相关权限
    if (await PermissionChecker.checkFacePermissions()) {
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
        titleText: SizedBox(
          height: Get.context!.height - 100,
          child: Column(
            children: [
              Text(
                "Face recognition in progress ...",
                style: TextStyle(
                  color: AppThemeStyle.white,
                  fontWeight: FontWeight.bold,
                ),
              ).marginOnly(bottom: 15),
              SpinKitDoubleBounce(
                color: ColorUtil.hex("#3fd4f6"),
                duration: const Duration(seconds: 3),
                size: 50,
              ),
            ],
          ),
        ).marginOnly(top: 30),

        /// sanckbar状态监听
        snackbarStatus: (status) {
          switch (status) {
            case SnackbarStatus.OPENING:
              HideCameraController.to.openFaceCamera();
              break;
            default:
          }
        },
      );
    }
  }

  /// 显示识别结果通知
  void showResult(FaceVerificationResult result) {
    Map tips = {
      0: [
        FontAwesomeIcons.solidFaceGrinTongueSquint,
        "Unlock !",
        AppThemeStyle.green,
      ],
      1: [
        FontAwesomeIcons.solidFaceMeh,
        "Who are you ?",
        AppThemeStyle.red,
      ],
      2: [
        FontAwesomeIcons.solidFaceMehBlank,
        "No Face !",
        AppThemeStyle.clearGrey
      ],
    };

    GetNotification.showCustomSnackbar(
      "",
      "",
      maxWidth: 150,
      borderRadius: 40,
      padding: const EdgeInsets.all(25),
      titleWidget: SizedBox(
        width: 180,
        child: Center(
          child: FaIcon(
            tips[result.index][0],
            size: 70,
            color: tips[result.index][2],
          ),
        ),
      ),
      messageWidget: Center(
        child: Text(
          tips[result.index][1],
          style: Theme.of(Get.context!)
              .textTheme
              .caption!
              .copyWith(color: tips[result.index][2]),
        ),
      ),
    );
  }

  /// 显示锁屏密码设置框
  void showLockPwsEditSheet() {
    String res = prefs.getString('lockPwd') ?? '';
    GetNotification.showCustomBottomSheet(
      title: 'Set lock screen password',
      confirmBorderColor: AppThemeStyle.clearGrey,
      confirmOnTap: () async {
        res = TextFieldController.to.editController.text;
        Get.back();
        await prefs.setString('lockPwd', res);
      },
      cancelOnTap: () => Get.back(),
      children: [
        const AppTextField(
          hintText: 'Input your password',
        ).marginSymmetric(vertical: 20),
      ],
    );
  }
}
