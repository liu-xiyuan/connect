import 'package:connect/common/color_util.dart';
import 'package:connect/controller/about_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutDialog extends GetView<AboutController> {
  const AboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.appName.value,
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            'v${controller.version.value}',
            style: Theme.of(context).textTheme.caption!,
          ).marginOnly(bottom: 5),
          Text(
            'Flutter based computer peripheral application',
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: AppThemeStyle.clearGrey,
                ),
          ).marginOnly(bottom: 5),
          FeedbackButton(
            onTap: () => controller.toGithubHome(),
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.github,
                    color: AppThemeStyle.blue,
                    size: 15,
                  ).marginOnly(right: 5),
                  Text(
                    'View in Github',
                    style: TextStyle(
                      color: AppThemeStyle.blue,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ).paddingSymmetric(vertical: 10),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                GetPlatform.isAndroid
                    ? FontAwesomeIcons.android
                    : FontAwesomeIcons.apple,
                color: GetPlatform.isAndroid
                    ? ColorUtil.hex("#00df7c")
                    : AppThemeStyle.white,
                size: 15,
              ).marginOnly(right: 5),
              Text(
                GetPlatform.isAndroid ? 'android' : 'iOS',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppThemeStyle.white,
                  height: GetPlatform.isAndroid ? .9 : 1.7,
                ),
              ),
            ],
          ).marginOnly(top: 20),
        ],
      ),
    );
  }
}
