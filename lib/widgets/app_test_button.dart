import 'dart:developer';

import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/pages/facial_expression_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AppTestButton extends StatelessWidget {
  const AppTestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void test() {
      Get.to(const FacialExpressionPage());
      // BluetoothController.to.sendKeyWithRelease('B');
    }

    return Visibility(
      visible: kDebugMode, // 在debug模式下显示此按钮
      child: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(.5),
        elevation: 0,
        highlightElevation: 0,
        onPressed: () => test(),
        child: const FaIcon(
          FontAwesomeIcons.boltLightning,
          color: Colors.black,
        ),
      ),
    );
  }
}
