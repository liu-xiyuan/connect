import 'package:connect/controller/text_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTextField extends GetView<TextFieldController> {
  const AppTextField({
    Key? key,
    this.autofocus,
    this.initText,
    this.hintText,
  }) : super(key: key);

  /// 初始文本
  final String? initText;

  /// 提示文本
  final String? hintText;

  /// 是否自动聚焦
  final bool? autofocus;

  @override
  Widget build(BuildContext context) {
    Get.put(TextFieldController());

    controller.editController.text = initText ?? '';

    return Container(
      height: 45,
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 6,
            color: Colors.grey.withOpacity(.3),
          ),
        ),
      ),
      child: TextField(
        autofocus: autofocus ?? false,
        textAlignVertical: TextAlignVertical.center, // 垂直居中对齐
        controller: controller.editController,
        cursorColor: Colors.black.withOpacity(.3), // 光标颜色
        cursorWidth: 2,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          textBaseline: TextBaseline.alphabetic,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(25) //限制长度
        ],
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            textBaseline: TextBaseline.alphabetic,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.only(left: 10),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
            onPressed: () {
              // 清空字符串
              controller.editController.clear();
            },
          ),
        ),
      ),
    );
  }
}
