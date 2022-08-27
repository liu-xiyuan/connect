import 'package:connect/common/color_util.dart';
import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/face_verification_controller.dart';
import 'package:connect/controller/services/speech_recognition_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/widgets/app_bottomsheet_box.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ToolboxBar extends StatelessWidget {
  const ToolboxBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBox(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.1),
          offset: const Offset(0, 2),
          spreadRadius: 2,
          blurRadius: 10,
        ),
      ],
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 电脑锁屏
            ToolboxBarItem(
              onTap: () {
                GetNotification.closeBottomSheet();
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
            ToolboxBarItem(
              onTap: () {
                GetNotification.closeBottomSheet();
                SpeechRecognitionController.to.showSpeechInterface();
              },
              title: 'Speech',
              // icon: AppCustomIcons.waveformLine,
              icon: FontAwesomeIcons.atom,
              iconColor: ColorUtil.hex("#ff9066"),
            ),

            // 面部解锁
            ToolboxBarItem(
              onTap: () {
                GetNotification.closeBottomSheet();
                FaceVerificationController.to.showFaceInterface();
              },
              title: 'Face Unlock',
              icon: FontAwesomeIcons.solidFaceGrinTongueSquint,
              iconColor: ColorUtil.hex("#39ceab"),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 蓝牙手柄
            ToolboxBarItem(
              onTap: () {
                GetNotification.closeBottomSheet();
              },
              title: 'Gamepad',
              icon: FontAwesomeIcons.gamepad,
              iconColor: ColorUtil.hex("#797dff"),
            ),

            // 手势识别
            ToolboxBarItem(
              onTap: () {
                GetNotification.closeBottomSheet();
              },
              title: 'Gesture',
              icon: FontAwesomeIcons.handSparkles,
              iconColor: ColorUtil.hex("#fec441"),
            ),

            // 媒体控制器
            ToolboxBarItem(
              onTap: () {
                GetNotification.closeBottomSheet();
                BluetoothController.to.showMediaInterface();
              },
              title: 'Media Control',
              icon: FontAwesomeIcons.icons,
              iconColor: ColorUtil.hex('#f65e6b'),
            ),
          ],
        ),
      ],
    );
  }
}

class ToolboxBarItem extends StatelessWidget {
  const ToolboxBarItem({
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
      enableVibrate: true,
      child: Container(
        color: Colors.transparent,
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 25,
              color: iconColor ?? Colors.black,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                // height: 1.4,
              ),
              textAlign: TextAlign.center,
            ).marginOnly(top: 5),
          ],
        ).marginSymmetric(vertical: 10),
      ),
    );
  }
}
