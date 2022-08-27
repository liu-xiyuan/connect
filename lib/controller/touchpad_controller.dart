import 'dart:developer';

import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

/// 触控板控制器
class TouchpadController extends GetxController {
  /// 缩放手势时的手指数
  var scalePointerCount = 0.obs;

  /// 缩放手势的Y轴缩放比例, 该值必须大于或等于0
  var scaleVerticalScale = 0.0.obs;

  /// 长按拖动手势的X轴偏移量
  double longPressMoveOffestX = 0.0;

  /// 长按拖动手势的Y轴偏移量
  double longPressMoveOffestY = 0.0;

  /// 初始化缩放手势监听
  // void initScaleListener() {
  //   ever(
  //     scaleVerticalScale,
  //     (callback) {
  //       if (scalePointerCount.value == 2) {
  //         if (scaleVerticalScale < 0.9) {
  //         } else if (scaleVerticalScale > 1.1) {
  //         }
  //       }
  //     },
  //   );
  // }

  /*
    ---------------
    ----双击手势----
    ---------------
  */
  void onDoubleTap() {
    // 双击
    // 将电脑端选中的文本复制到手机
    TcpServiceController.to.sendData(
      TcpCommands.otherAction,
      OtherAction.copyText,
    );
  }

  /*
    ---------------
    ----缩放手势----
    ---------------
  */
  void onScaleUpdate(ScaleUpdateDetails e) {
    scalePointerCount.value = e.pointerCount;
    scaleVerticalScale.value = double.parse(e.verticalScale.toStringAsFixed(1));
    // log('pointerCount: $scalePointerCount|verticalScale: $scaleVerticalScale|');
  }

  void onScaleEnd() {
    if (scalePointerCount.value == 2 && scaleVerticalScale < 0.5) {
      // 双指捏合
      log('ZOOM_IN');
    } else if (scalePointerCount.value == 2 && scaleVerticalScale > 1.5) {
      // 双指张开
      log('ZOOM_OUT');
    } else if (scalePointerCount.value == 3 && scaleVerticalScale < .5) {
      // 三指捏合
      // --显示所有程序窗口(win + tab)
      TcpServiceController.to.sendData(
        TcpCommands.keyboardAction,
        KeyboardAction.showProgramWindow,
      );
    } else if (scalePointerCount.value == 3 && scaleVerticalScale > 1.5) {
      /// 三指张开
    }
    // log('${scalePointerCount} | ${scaleVerticalScale}');
  }

  /*
    ---------------
    ----长按手势----
    ---------------
  */
  void onLongPressStart() {
    Vibrate.feedback(FeedbackType.success); // 震动提示
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails e) {
    longPressMoveOffestX = e.localOffsetFromOrigin.dx;
    longPressMoveOffestY = e.localOffsetFromOrigin.dy;
  }

  void onLongPressEnd() {
    log(longPressMoveOffestY.toString());
    if (longPressMoveOffestX > 120) {
      // 长按并向右轻扫
      // --切换为下一个桌面
      TcpServiceController.to.sendData(
        TcpCommands.keyboardAction,
        KeyboardAction.switchDesktop,
        data: 'right',
      );
    } else if (longPressMoveOffestX < -120) {
      // 长按并向左轻扫
      // --切换为上一个桌面
      TcpServiceController.to.sendData(
        TcpCommands.keyboardAction,
        KeyboardAction.switchDesktop,
        data: 'left',
      );
    } else if (longPressMoveOffestY > 120) {
      // 长按并向下轻扫

    } else if (longPressMoveOffestY < -120) {
      // 长按并向上轻扫
    }

    longPressMoveOffestX = 0;
    longPressMoveOffestY = 0;
  }
}
