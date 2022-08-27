import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPageAppbar extends StatelessWidget {
  const AppPageAppbar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.isShowLeading = true,
  }) : super(key: key);

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool isShowLeading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // leading
          Visibility(
            visible: isShowLeading,
            child: leading ??
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
          ),
          const Expanded(child: SizedBox(width: double.infinity)), // 撑开组件
          // title
          Center(
            child: Text(
              title ?? '',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          const Expanded(child: SizedBox(width: double.infinity)),
          // actions
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions ?? [],
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 15),
    );
  }
}
