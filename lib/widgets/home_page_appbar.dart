import 'package:connect/controller/home_controller.dart';
import 'package:connect/controller/lab/shutdown_controller.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/ml_awareness_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tcp_client_dart/tcp_client_dart.dart';

class HomePageAppbar extends GetView<HomeController> {
  const HomePageAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Obx(
      () => SafeArea(
        child: HomeAppbar(
          leading: SizedBox(
            width: 250,
            height: 25,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                StatusTag(
                  tagTitle: "TCP",
                  onTap: () => TcpServiceController.to.connect(),
                  onLongPress: () {
                    Vibrate.feedback(FeedbackType.success); // 震动提示
                    TcpServiceController.to.showEditSheet(isSavedConnect: true);
                  },
                  leading: SpinKitDoubleBounce(
                    color: TcpServiceController.to.tcpSocketState.value ==
                            TcpConnectionState.connected
                        ? AppThemeStyle.green
                        : AppThemeStyle.red,
                    duration: const Duration(seconds: 3),
                    size: 8,
                  ).marginOnly(right: 5),
                ),
                StatusTag(
                  tagTitle: "Blue",
                  onTap: () => BluetoothController.to.connect(),
                  onLongPress: () {
                    Vibrate.feedback(FeedbackType.success); // 震动提示
                    BluetoothController.to.showEditSheet(isSavedConnect: true);
                  },
                  leading: SpinKitDoubleBounce(
                    color: BluetoothController.to.isConnected.value
                        ? AppThemeStyle.green
                        : AppThemeStyle.red,
                    duration: const Duration(seconds: 5),
                    size: 8,
                  ).marginOnly(right: 5),
                ),
                Visibility(
                  visible: ShutdownController.to.isTiming.value,
                  child: StatusTag(
                    tagTitle:
                        "${ShutdownController.to.shutdownData.value.hour.toString().padLeft(2, '0')} : ${ShutdownController.to.shutdownData.value.minute.toString().padLeft(2, '0')}",
                    onTap: () {
                      ShutdownController.to.cancelShutdown();
                    },
                    leading: FaIcon(
                      FontAwesomeIcons.clockRotateLeft,
                      color: AppThemeStyle.white,
                      size: 8,
                    ).marginOnly(right: 5),
                    backgroundColor: AppThemeStyle.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // 夜间
            Visibility(
              visible: MlAwarenessController.to.isNight.value,
              child: FaIcon(
                FontAwesomeIcons.solidMoon,
                size: 12,
                color: AppThemeStyle.white,
              ).marginSymmetric(horizontal: 3),
            ),
            // 电池状态
            FaIcon(
              MlAwarenessController.to.batterLevelIcon.value,
              size: 16,
              color: MlAwarenessController.to.batterLevelColor.value,
            ).marginSymmetric(horizontal: 3),
            // 充电提示
            Visibility(
              visible: MlAwarenessController.to.isCharging.value,
              child: FaIcon(
                FontAwesomeIcons.bolt,
                size: 8,
                color: AppThemeStyle.green,
              ),
            ).marginSymmetric(horizontal: 2),
          ],
        ),
      ),
    );
  }
}

/// 位于AppBar的TCP状态小标签
class StatusTag extends StatelessWidget {
  const StatusTag({
    Key? key,
    required this.onTap,
    required this.tagTitle,
    this.leading = const SizedBox(),
    this.backgroundColor = Colors.transparent,
    this.onLongPress,
  }) : super(key: key);

  final Function() onTap;
  final Function()? onLongPress;
  final Widget leading;
  final String tagTitle;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return FeedbackButton(
      onTap: onTap,
      onLongPress: onLongPress,
      enableVibrate: true,
      child: Container(
        height: 25,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            leading,
            Text(
              tagTitle,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }
}

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.isShowLeading = true,
  }) : super(key: key);

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool isShowLeading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // leading
          Visibility(
            visible: isShowLeading,
            child: leading ??
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
          ),
          const Expanded(child: SizedBox(width: double.infinity)), // 撑开组件
          // title
          Center(
            child: Text(
              title ?? '',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          const Expanded(child: SizedBox(width: double.infinity)),
          // actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: actions ?? [],
          ),
        ],
      ).paddingSymmetric(horizontal: 25),
    );
  }
}
