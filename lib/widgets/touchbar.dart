import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/controller/touchbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcp_client_dart/tcp_client_dart.dart';

/// 触控条
class Touchbar extends GetView<TouchbarController> {
  const Touchbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TouchbarController());

    double horizontalOffest = 0; // 左右滑动的偏移量
    double verticalOffest = 0; // 上下滑动的偏移量

    return Obx(
      () => AbsorbPointer(
        absorbing: TcpServiceController.to.tcpSocketState.value ==
                TcpConnectionState.connected
            ? false
            : true,
        child: GestureDetector(
          onDoubleTap: () => controller.onDoubleTap(),
          onLongPress: () => controller.onLongPress(),

          // 左右滑动
          onHorizontalDragUpdate: (e) => horizontalOffest = e.delta.dx,
          onHorizontalDragEnd: (e) {
            controller.onHorizontalDrag(horizontalOffest);
          },

          // 上下滑动
          onVerticalDragUpdate: (e) => verticalOffest = e.delta.dy + .5,
          onVerticalDragEnd: (d) {
            controller.onVerticalDrag(verticalOffest);
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 30, 35),
            width: 300,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.5),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
    );
  }
}
