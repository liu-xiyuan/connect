import 'package:connect/common/color_util.dart';
import 'package:connect/controller/about_controller.dart';
import 'package:connect/widgets/app_page_template.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget inkBar({
      required Function() onTop,
      required IconData icon,
      required String title,
    }) {
      return FeedbackButton(
        onTap: onTop,
        child: Container(
          width: 200,
          color: Colors.transparent,
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: FaIcon(
                  icon,
                  color: Colors.black,
                  size: 20,
                ),
              ).marginOnly(right: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ).paddingSymmetric(vertical: 10),
        ),
      );
    }

    Get.put(AboutController());

    return AppPageTemplate(
      flootTitle: 'Copyright ©2049 Connect All Rights Reserved',
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: context.width),
            // App名称
            Text(
              controller.appName.value,
              style:
                  Theme.of(context).textTheme.headline2?.copyWith(fontSize: 50),
            ).marginSymmetric(vertical: 5),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 版本信息
                Text(
                  'v${controller.version.value}',
                  style: const TextStyle(color: Colors.black),
                ).marginOnly(bottom: 5),
                // 介绍
                const Text(
                  'Flutter based computer peripheral app',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ).marginOnly(bottom: 30),
                // 链接
                inkBar(
                  onTop: () => {},
                  icon: FontAwesomeIcons.earthAsia,
                  title: 'Check for updates',
                ),
                inkBar(
                  onTop: () => {},
                  icon: FontAwesomeIcons.github,
                  title: 'GitHub',
                ),
                inkBar(
                  onTop: () => {},
                  icon: FontAwesomeIcons.solidCircleQuestion,
                  title: 'Help',
                ),
              ],
            ).paddingOnly(left: 5),

            // 当前设备系统图标
            const Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  GetPlatform.isAndroid
                      ? FontAwesomeIcons.android
                      : FontAwesomeIcons.apple,
                  color: GetPlatform.isAndroid
                      ? ColorUtil.hex("#00df7c")
                      : Colors.black,
                ).marginOnly(right: 10),
                Text(
                  GetPlatform.isAndroid ? 'android' : 'iOS',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    height: GetPlatform.isAndroid ? null : 1.8,
                  ),
                ),
              ],
            ).marginOnly(bottom: 20),
          ],
        ).marginSymmetric(horizontal: 15),
      ),
    );
  }
}
