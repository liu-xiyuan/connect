import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldController extends GetxController {
  static TextFieldController get to => Get.find();

  /// 输入框控制器
  TextEditingController editController = TextEditingController();

  @override
  void onClose() {
    super.onClose();
    editController.clear();
  }
}
