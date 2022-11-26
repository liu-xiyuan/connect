import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/controller/settings_controller.dart';
import 'package:connect/style/app_theme_style.dart';
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
                  settingInfo: TcpServiceController.to.ipAddress.value,
                  onTap: () => TcpServiceController.to.showEditSheet(),
                ),
                SettingsItem(
                  title: 'LockScreen Password',
                  onTap: () {
                    GetNotification.showCustomBottomSheet(
                      title: 'Set lock screen password',
                      confirmBorderColor: AppThemeStyle.white,
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
                  settingInfo: BluetoothController.to.macAddress.value,
                  onTap: () => BluetoothController.to.showEditSheet(),
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
