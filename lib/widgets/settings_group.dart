import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// 设置页面的设置组 组件
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    Key? key,
    this.title,
    required this.items,
  }) : super(key: key);

  ///设置组的标题
  final String? title;

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 设置组标题
          Text(
            title ?? '',
            style: Theme.of(context).textTheme.caption!.copyWith(
                  color: AppThemeStyle.clearGrey,
                  fontWeight: FontWeight.normal,
                ),
          ).marginOnly(top: 25),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: items,
          ),
          const Divider().marginOnly(top: 5),
        ],
      ),
    );
  }
}

/// 子组件
class SettingsItem extends StatelessWidget {
  const SettingsItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.settingInfo,
  }) : super(key: key);

  final Function() onTap;
  final String title;
  final String? settingInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1!,
          ),
          const Expanded(child: SizedBox()),
          Text(
            settingInfo ?? '',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: AppThemeStyle.clearGrey,
                  fontWeight: FontWeight.normal,
                ),
          ),
          FaIcon(
            FontAwesomeIcons.angleRight,
            size: 15,
            color: AppThemeStyle.clearGrey,
          ).marginOnly(left: 15),
        ],
      ).marginSymmetric(vertical: 20),
    );
  }
}
