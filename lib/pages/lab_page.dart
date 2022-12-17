import 'package:connect/controller/lab/shutdown_controller.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/common/permission_checker.dart';
import 'package:connect/widgets/app_page_template.dart';
import 'package:connect/widgets/lab_item_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LabPage extends GetView<ShutdownController> {
  const LabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppPageTemplate(
      appBarTitle: 'Laboratory',
      subPageTitle: 'Some interesting and/or useless functions',
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 30,
          mainAxisSpacing: 20,
          childAspectRatio: .8,
        ),
        physics: const BouncingScrollPhysics(),
        children: [
          //
          LabItemCard(
            title: 'Smile Shot Detection',
            onTap: () async {
              if (await PermissionChecker.checkFacePermissions() &&
                  BluetoothController.to.checkBluetooth()) {
                Get.toNamed('/expression');
              }
            },
            icons: const [
              FontAwesomeIcons.solidFaceLaughSquint,
              FontAwesomeIcons.gun,
              FontAwesomeIcons.fire,
            ],
          ),

          //
          LabItemCard(
            title: 'Timed Shutdown',
            onTap: () {
              controller.showEditTimeBottomSheet();
            },
            icons: const [
              FontAwesomeIcons.solidClock,
              FontAwesomeIcons.powerOff,
              FontAwesomeIcons.desktop,
            ],
          ),
        ],
      ),
    );
  }
}
