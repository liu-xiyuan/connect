import 'package:connect/controller/home_controller.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/style/color_palette.dart';
import 'package:connect/widgets/app_page_appbar.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        child: AppPageAppbar(
          leading: SizedBox(
            width: 250,
            height: 25,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                StatusTag(
                  tagTitle: "TCP",
                  onTap: () => TcpServiceController.to.connectToPCserver(),
                  leading: SpinKitDoubleBounce(
                    color: TcpServiceController.to.tcpSocketState.value ==
                            TcpConnectionState.connected
                        ? ColorPalette.green
                        : Colors.red,
                    duration: const Duration(seconds: 3),
                    size: 8,
                  ).marginOnly(right: 5),
                ),
                StatusTag(
                  tagTitle: "Blue",
                  onTap: () => BluetoothController.to.connect(),
                  leading: SpinKitDoubleBounce(
                    color: BluetoothController.to.isConnected.value
                        ? ColorPalette.green
                        : Colors.red,
                    duration: const Duration(seconds: 5),
                    size: 8,
                  ).marginOnly(right: 5),
                ),
                // StatusTag(
                //   onTap: () {
                //     GetNotification.showToast(message: 'Already in Touch Mode');
                //   },
                //   tagTitle: "Touch Mode",
                //   backgroundColor: ColorPalette.green.withOpacity(.1),
                // ),
              ],
            ),
          ),
          actions: [
            // 弹出式菜单
            PopupMenuButton(
              icon: const Center(
                // child: FaIcon(FontAwesomeIcons.ellipsisVertical),
                child: FaIcon(FontAwesomeIcons.ellipsis),
              ),
              offset: const Offset(0, 40),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // 边框圆角
              ),
              color: Colors.white.withOpacity(.3),
              tooltip: '', // 取消长按提示

              itemBuilder: (_) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    value: 'settings',
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                    child: const Text('Settings'),
                  ),
                  PopupMenuItem(
                    value: 'toolbox',
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                    child: const Text('Toolbox'),
                  ),
                  PopupMenuItem(
                    value: 'about',
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                    child: const Text('About'),
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 'settings':
                    Get.toNamed('/settings');
                    break;
                  case 'toolbox':
                    controller.showToolboxBar();
                    break;
                  case 'about':
                    Get.toNamed('/about');
                    break;
                  default:
                }
              },
              onCanceled: () {},
            ),
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
    this.backgroundColor = Colors.white54,
  }) : super(key: key);

  final Function() onTap;
  final Widget leading;
  final String tagTitle;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return FeedbackButton(
      onTap: onTap,
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
              style: const TextStyle(
                fontSize: 10,
                height: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    ).marginOnly(right: 10);
  }
}
