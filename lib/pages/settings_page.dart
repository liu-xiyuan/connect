import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/settings_controller.dart';
import 'package:connect/widgets/app_page_template.dart';
import 'package:connect/widgets/app_text_field.dart';
import 'package:connect/widgets/settings_group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    return AppPageTemplate(
      pageTitle: 'Settings',
      flootTitle: 'Copyright ©2049 Connect All Rights Reserved',
      child: Obx(
        () => Column(
          children: [
            /*
              --------TCP--------
            */
            SettingsGroup(
              title: 'TCP',
              items: [
                SettingsItem(
                  title: 'IP Address',
                  settingInfo: controller.ipAddress.value,
                  onTap: () {
                    GetNotification.showCustomBottomSheet(
                      title: 'Set ip address',
                      confirmTextColor: Colors.black,
                      confirmBorderColor: Colors.black,
                      confirmOnTap: () {
                        controller.updateIpAddress();
                        Get.back();
                      },
                      cancelOnTap: () => Get.back(),
                      children: [
                        AppTextField(
                          initText: controller.ipAddress.value,
                          hintText: 'Input: 192.127.0.106:8888',
                        ).marginSymmetric(vertical: 20),
                      ],
                    );
                  },
                ),
                SettingsItem(
                  title: 'LockScreen Password',
                  onTap: () {
                    GetNotification.showCustomBottomSheet(
                      title: 'Set lock screen password',
                      confirmTextColor: Colors.black,
                      confirmBorderColor: Colors.black,
                      confirmOnTap: () {
                        controller.updateLockPassword();
                        Get.back();
                      },
                      cancelOnTap: () => Get.back(),
                      children: [
                        const AppTextField().marginSymmetric(vertical: 20),
                      ],
                    );
                  },
                ),
              ],
            ),
            /*
              --------蓝牙--------
            */
            SettingsGroup(
              title: 'Bluetooth',
              items: [
                SettingsItem(
                  title: 'MAC Address',
                  settingInfo: controller.macAddress.value,
                  onTap: () {
                    GetNotification.showCustomBottomSheet(
                      title: 'Set mac address',
                      confirmTextColor: Colors.black,
                      confirmBorderColor: Colors.black,
                      confirmOnTap: () {
                        controller.updateMacAddress();
                        Get.back();
                      },
                      cancelOnTap: () => Get.back(),
                      children: [
                        AppTextField(
                          initText: controller.macAddress.value,
                          hintText: 'Input: 35:7G:F4:77:C2:9F',
                        ).marginSymmetric(vertical: 20),
                      ],
                    );
                  },
                )
              ],
            ),
            const Expanded(child: SizedBox(height: double.infinity)),
          ],
        ),
      ),
    );
  }
}
