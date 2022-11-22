import 'package:connect/controller/lab/facial_expression_controller.dart';
import 'package:connect/controller/services/hide_camera_controller.dart';
import 'package:connect/style/app_theme_style.dart';
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
    double imgWidth = 350;

    return AppPageTemplate(
      appBarTitle: 'Smile to Shot !',
      subPageTitle: 'To play games with a smile. (key: B)',
      child: Obx(
        () => Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // 预览图像
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: MLBodyLens(
                  textureId: HideCameraController.to.textureId.value,
                  width: imgWidth,
                  height: imgWidth * 3 / 4,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: FaIcon(
                  controller.smiling.value
                      ? FontAwesomeIcons.faceLaugh
                      : FontAwesomeIcons.faceMeh,
                  size: 60,
                  color: controller.smiling.value
                      ? Colors.green
                      : AppThemeStyle.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
