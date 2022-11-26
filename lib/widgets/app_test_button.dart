// ignore_for_file: unused_import, unnecessary_import

import 'dart:developer';
import 'dart:ffi';
import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/ml_awareness_controller.dart';
import 'package:connect/controller/services/ml_face_controller.dart';
import 'package:connect/controller/services/ml_speech_controller.dart';
import 'package:connect/controller/services/ml_translator_controller.dart';
import 'package:connect/controller/services/permission_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/pages/facial_expression_page.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:huawei_awareness/huawei_awareness.dart';
import 'package:huawei_ml_language/huawei_ml_language.dart';
import 'package:power/power.dart';

class AppTestButton extends StatelessWidget {
  const AppTestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void test() async {
      MlTranslatorController.to.startRealTimeTranslate();
    }

    return Visibility(
      visible: kDebugMode, // 在debug模式下显示此按钮
      child: FloatingActionButton(
        backgroundColor: AppThemeStyle.darkGrey.withOpacity(.6),
        elevation: 0,
        highlightElevation: 0,
        onPressed: () => test(),
        child: const FaIcon(
          FontAwesomeIcons.boltLightning,
          color: Colors.white,
        ),
      ),
    );
  }
}
