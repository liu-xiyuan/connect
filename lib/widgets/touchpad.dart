import 'dart:developer';

import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/controller/touchpad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcp_client_dart/tcp_client_dart.dart';

/// 触控板
class Touchpad extends GetView<TouchpadController> {
  const Touchpad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TouchpadController());
    return Obx(
      () => AbsorbPointer(
        absorbing: TcpServiceController.to.tcpSocketState.value ==
                TcpConnectionState.connected
            ? false
            : true,
        child: GestureDetector(
          onScaleUpdate: (e) => controller.onScaleUpdate(e),
          onScaleEnd: (e) => controller.onScaleEnd(),
          onDoubleTap: () => controller.onDoubleTap(),
          onLongPressMoveUpdate: (e) => controller.onLongPressMoveUpdate(e),
          onLongPressStart: (_) => controller.onLongPressStart(),
          onLongPressEnd: (_) => controller.onLongPressEnd(),
          child: SizedBox(
            height: context.height,
            width: context.width,
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
