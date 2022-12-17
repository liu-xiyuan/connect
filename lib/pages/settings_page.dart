import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/ml_face_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/widgets/app_page_template.dart';
import 'package:connect/widgets/settings_group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppPageTemplate(
      pageTitle: 'Settings',
      // flootTitle: 'Copyright ©2049 Connect All Rights Reserved',
      child: Obx(
        () => SingleChildScrollView(
          child: Column(
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
                    onTap: () => TcpServiceController.to.showIpEditSheet(),
                  ),
                  SettingsItem(
                    title: 'LockScreen Password',
                    onTap: () => MlFaceController.to.showLockPwsEditSheet(),
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
            ],
          ),
        ),
      ),
    );
  }
}
