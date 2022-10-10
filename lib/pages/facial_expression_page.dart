import 'dart:developer';

import 'package:connect/controller/services/facial_expression_controller.dart';
import 'package:connect/controller/services/hide_camera_controller.dart';
import 'package:connect/style/color_palette.dart';
import 'package:connect/widgets/app_page_template.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:huawei_ml_body/huawei_ml_body.dart';

class FacialExpressionPage extends GetView<FacialExpressionController> {
  const FacialExpressionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FacialExpressionController());
    log((context.width - 50).toString());
    return AppPageTemplate(
      pageTitle: 'Smile to Shot!',
      subPageTitle: 'To play games with a smile.',
      child: Obx(
        () => Column(
          children: [
            // 预览图像
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: MLBodyLens(
                textureId: HideCameraController.to.textureId.value,
                width: context.width,
                height: (context.width - 50) * 16 / 11.5,
              ),
            ),

            const Expanded(child: SizedBox()),
            FaIcon(
              controller.smiling.value
                  ? FontAwesomeIcons.faceLaugh
                  : FontAwesomeIcons.faceMeh,
              size: 60,
              color: controller.smiling.value ? Colors.green : ColorPalette.red,
            ),

            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
