import 'package:connect/common/color_util.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/ml_face_controller.dart';
import 'package:connect/controller/services/ml_speech_controller.dart';
import 'package:connect/controller/services/ml_translator_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/controller/tool_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/app_page_template.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ToolPage extends GetView<ToolController> {
  const ToolPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ToolController());
    return AppPageTemplate(
      appBarTitle: "Tools",
      leading: const SizedBox(),
      child: GestureDetector(
        onHorizontalDragUpdate: (e) => controller.onHorizontalDragUpdate(e),
        onHorizontalDragEnd: (_) => controller.onHorizontalDragEnd(),
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.2,
            crossAxisCount: 5,
            crossAxisSpacing: 70,
            mainAxisSpacing: 70,
          ),
          children: [
            // 电脑锁屏
            ToolItem(
              onTap: () {
                Get.offNamed('/');
                TcpServiceController.to.sendData(
                  TcpCommands.otherAction,
                  OtherAction.lockScreen,
                );
              },
              title: 'Lock Screen',
              icon: FontAwesomeIcons.lock,
              iconColor: ColorUtil.hex("#3fd4f6"),
            ),

            // 语音
            ToolItem(
              onTap: () {
                Get.offNamed('/');
                MlSpeechController.to.showSpeechInterface();
              },
              title: 'Speech',
              // icon: AppCustomIcons.waveformLine,
              icon: FontAwesomeIcons.atom,
              iconColor: ColorUtil.hex("#ff9066"),
            ),

            // 面部解锁
            ToolItem(
              onTap: () {
                Get.back();
                MlFaceController.to.showFaceInterface();
              },
              title: 'Face Unlock',
              icon: FontAwesomeIcons.solidFaceGrinTongueSquint,
              iconColor: ColorUtil.hex("#39ceab"),
            ),

            // 实时翻译
            ToolItem(
              onTap: () => MlTranslatorController.to.showRealTimeTranslate(),
              title: 'Translator',
              icon: FontAwesomeIcons.solidClosedCaptioning,
              iconColor: ColorUtil.hex("#fec441"),
            ),

            // 实验室
            ToolItem(
              onTap: () {
                Get.toNamed('/lab');
              },
              title: 'Laboratory',
              icon: FontAwesomeIcons.microscope,
              iconColor: ColorUtil.hex("#797dff"),
            ),

            // 媒体控制器
            ToolItem(
              onTap: () {
                BluetoothController.to.showMediaInterface();
              },
              title: 'Media Control',
              icon: FontAwesomeIcons.icons,
              iconColor: ColorUtil.hex('#f65e6b'),
            ),

            // 设置页面
            ToolItem(
              onTap: () {
                Get.toNamed('/settings');
              },
              title: 'Settings',
              icon: FontAwesomeIcons.gear,
              iconColor: ColorUtil.hex('#3bc4c3'),
            ),

            // 关于页面
            ToolItem(
              onTap: () {
                Get.toNamed('/about');
              },
              title: 'About',
              icon: FontAwesomeIcons.circleInfo,
              iconColor: ColorUtil.hex('#fe759f'),
            ),
          ],
        ),
      ),
    );
  }
}

class ToolItem extends StatelessWidget {
  const ToolItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
  }) : super(key: key);

  final Function() onTap;
  final IconData icon;
  final Color? iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FeedbackButton(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: 50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 30,
              color: iconColor ?? AppThemeStyle.white,
            ).marginOnly(bottom: 15),
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
          ],
        ).marginSymmetric(vertical: 10),
      ),
    );
  }
}
