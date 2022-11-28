import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppTestButton extends StatelessWidget {
  const AppTestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: kDebugMode, // 在debug模式下显示此按钮
      child: FloatingActionButton(
        onPressed: () async {
          // GetNotification.showCustomSnackbar('title', 'message');
        },
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
