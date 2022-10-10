import 'package:connect/common/color_util.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LabItemCard extends StatelessWidget {
  const LabItemCard({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icons,
  }) : super(key: key);

  final Function() onTap;
  final String title;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    List<Widget> iconList = [];

    for (var item in icons) {
      iconList.add(
        FaIcon(
          item,
          color: Colors.white,
          size: 30,
        ),
      );
    }
    return FeedbackButton(
      onTap: onTap,
      child: Container(
        width: context.width,
        height: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              ColorUtil.hex('#434343'),
              Colors.black,
            ],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: iconList,
            ),
            const Expanded(child: SizedBox()),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).marginOnly(bottom: 10),
            const Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                FaIcon(
                  FontAwesomeIcons.arrowRightToBracket,
                  size: 18,
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
