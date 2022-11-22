import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// page模板

class AppPageTemplate extends StatelessWidget {
  const AppPageTemplate({
    Key? key,
    this.appBarTitle = "",
    this.appBarActions = const [],
    this.subPageTitle,
    this.pageTitle,
    required this.child,
    this.flootTitle,
    this.leading,
  }) : super(key: key);
  final String appBarTitle;
  final List<Widget> appBarActions;
  final String? pageTitle;
  final String? subPageTitle;
  final Widget child;
  final String? flootTitle;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: leading ??
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.angleLeft,
                color: AppThemeStyle.white,
              ),
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
            // 页面标题
            pageTitle == null
                ? const SizedBox()
                : Text(
                    pageTitle!,
                    style: Theme.of(context).textTheme.headline1,
                  ).marginSymmetric(vertical: 10),
            //页面副标题
            subPageTitle == null
                ? const SizedBox()
                : Text(
                    subPageTitle!,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppThemeStyle.clearGrey,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                  ).marginOnly(bottom: 20),
            Expanded(child: child.marginOnly(top: 15)),
            Align(
              alignment: Alignment.center,
              child: Text(
                flootTitle ?? '',
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
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
