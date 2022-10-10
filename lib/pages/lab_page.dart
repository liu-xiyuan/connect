import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/permission_controller.dart';
import 'package:connect/widgets/app_page_template.dart';
import 'package:connect/widgets/lab_item_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LabPage extends StatelessWidget {
  const LabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppPageTemplate(
      pageTitle: 'Laboratory',
      subPageTitle: 'Some interesting and/or useless functions',
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 20,
          childAspectRatio: .8,
        ),
        physics: const BouncingScrollPhysics(),
        children: [
          //
          LabItemCard(
            onTap: () async {
              if (await PermissionController.to.checkFacePermissions() &&
                  BluetoothController.to.checkBluetooth()) {
                Get.toNamed('/expression');
              }
            },
            title: 'Smile Shot Detection',
            icons: const [
              FontAwesomeIcons.solidFaceLaughSquint,
              FontAwesomeIcons.gun,
              FontAwesomeIcons.fire,
            ],
          ),
        ],
      ),
    );
  }
}
