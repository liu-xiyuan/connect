import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// page模板

class AppPageTemplate extends StatelessWidget {
  const AppPageTemplate({
    Key? key,
    this.appBarTitle = "",
    this.appBarActions = const [],
    this.subPageTitle = const SizedBox(),
    this.pageTitle = "",
    required this.child,
    this.flootTitle,
  }) : super(key: key);
  final String appBarTitle;
  final List<Widget> appBarActions;
  final String pageTitle;
  final Widget subPageTitle;
  final Widget child;
  final String? flootTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
          onPressed: () => Get.back(),
        ).marginOnly(left: 10),
        title: Text(appBarTitle),
        actions: appBarActions,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pageTitle == ''
                ? const SizedBox()
                : Text(
                    pageTitle.tr,
                    style: const TextStyle(
                      fontSize: 30,
                      height: 1.1,
                      color: Colors.black,
                    ),
                  ).marginSymmetric(vertical: 10),
            // SizedBox.expand(
            //   child: child.marginOnly(top: 15),
            // ),
            Expanded(child: child.marginOnly(top: 15)),
            // const Expanded(child: SizedBox(height: double.infinity)),
            Align(
              alignment: Alignment.center,
              child: Text(
                flootTitle ?? '',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ).marginOnly(bottom: 25),
          ],
        ),
      ),
    );
  }
}
