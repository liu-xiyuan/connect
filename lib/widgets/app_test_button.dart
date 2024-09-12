import 'package:connect/common/get_notification.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/app_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AppTestButton extends StatelessWidget {
  const AppTestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: kDebugMode, // 在debug模式下显示此按钮
      child: FloatingActionButton(
        /// --------------------------
        ///
        /// --------------------------
        ///
        onPressed: () async {
          GetNotification.showCustomBottomSheet(
            title: 'Set IP address',
            message: 'A message should be a short, complete sentence.',
            confirmTitle: "Save & Connect",
            confirmBorderColor: AppThemeStyle.white.withOpacity(.2),
            confirmOnTap: () {},
            cancelOnTap: () => Get.back(),
            children: [
              // AppTextField(
              //   initText: 'Test! 192.127.0.106:8888',
              //   hintText: 'Input: 192.127.0.106:8888',
              // ),
            ],
          );
        },

        /// --------------------------
        ///
        /// --------------------------
        backgroundColor: AppThemeStyle.darkGrey.withOpacity(.8),
        elevation: 0,
        highlightElevation: 0,
        child: const FaIcon(
          FontAwesomeIcons.boltLightning,
          color: Colors.white,
        ),
      ),
    );
  }
}
