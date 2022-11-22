import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToolController extends GetxController {
  /// 左右滑动的偏移量
  var offestX = .0;

  /// 手势操作！

  /// 左右滑动
  void onHorizontalDragUpdate(DragUpdateDetails e) {
    offestX = e.delta.dx;
  }

  void onHorizontalDragEnd() {
    // offset > a :右滑 | offset < a :左滑
    if (offestX > 5) {
      Get.back();
    } else if (offestX < -5) {}
  }
}
