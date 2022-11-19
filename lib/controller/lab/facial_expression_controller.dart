import 'dart:developer';

import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/hide_camera_controller.dart';
import 'package:get/get.dart';
import 'package:huawei_ml_body/huawei_ml_body.dart';

/// 面部表情模拟输入
class FacialExpressionController extends GetxController {
  /// 是否微笑
  var smiling = false.obs;

  /// 表情微笑的概率值
  var smilingProbability = .0.obs;

  @override
  void onInit() {
    super.onInit();
    start();
  }

  /// 开始识别面部表情
  void start() async {
    await HideCameraController.to.initCameraEngine(
      bodyTransaction: BodyTransaction.face,
      onTransaction: ({dynamic result}) {
        // 监听相机返回的面部信息结果
        MLFace mlFace = result[0];

        smilingProbability.value = mlFace.emotions?.smilingProbability;

        // 如果微笑的概率值大于70%就执行:
        if (mlFace.emotions?.smilingProbability > .7) {
          if (smiling.value == false) {
            smiling.value = true;
            BluetoothController.to.sendKey('b');
          }
        } else if (smiling.value == true) {
          BluetoothController.to.sendKeyRelease();
          smiling.value = false;
        }
      },
    );
    HideCameraController.to.cameraEngine.run();
  }

  @override
  void onClose() {
    super.onClose();
    // 关闭相机, 释放资源
    HideCameraController.to.cameraEngine.release();
    BluetoothController.to.sendKeyRelease();
  }
}
