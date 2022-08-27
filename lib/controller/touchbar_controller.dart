import 'dart:developer';
import 'package:connect/controller/home_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

/// 触控条控制器
class TouchbarController extends GetxController {
  /// 长按指示条
  /// --显示快捷功能条
  void onLongPress() {
    HomeController.to.showToolboxBar();
  }

  /// 双击指示条
  /// --模拟Enter键
  void onDoubleTap() {
    Vibrate.feedback(FeedbackType.success);
    TcpServiceController.to.sendData(
      TcpCommands.keyboardAction,
      KeyboardAction.tapEnter,
    );
  }

  /// 左右滑动
  /// --模拟右方向键
  void onHorizontalDrag(double offset) {
    // offset > 2 :右滑 | offset < -2 :左滑
    if (offset > 2) {
      TcpServiceController.to.sendData(
        TcpCommands.keyboardAction,
        KeyboardAction.tapArrowKey,
        data: 'right',
      );
    } else if (offset < -2) {
      TcpServiceController.to.sendData(
        TcpCommands.keyboardAction,
        KeyboardAction.tapArrowKey,
        data: 'left',
      );
    }
  }

  /// 上下滑动
  /// --模拟上下方向键
  void onVerticalDrag(double offset) {
    // offset > 0 :下滑
    if (offset > 0) {
      TcpServiceController.to.sendData(
        TcpCommands.keyboardAction,
        KeyboardAction.tapArrowKey,
        data: 'down',
      );
    } else if (offset < 0) {
      TcpServiceController.to.sendData(
        TcpCommands.keyboardAction,
        KeyboardAction.tapArrowKey,
        data: 'up',
      );
    }
    log(offset.toString());
  }
}
