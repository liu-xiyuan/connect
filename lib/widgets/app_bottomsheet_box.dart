// import 'package:connect/style/app_theme_style.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// /// BottomSheet外框样式
// class AppBottomSheetBox extends StatelessWidget {
//   const AppBottomSheetBox({
//     Key? key,
//     this.children = const <Widget>[],
//     this.boxShadow,
//     this.direction = Axis.vertical,
//     this.mainAxisAlignment = MainAxisAlignment.center,
//     this.crossAxisAlignment = CrossAxisAlignment.center,
//     this.padding,
//     this.margin,
//     this.backgroundColor,
//   }) : super(key: key);

//   final List<Widget> children;
//   final List<BoxShadow>? boxShadow;
//   final Axis direction;
//   final CrossAxisAlignment crossAxisAlignment;
//   final MainAxisAlignment mainAxisAlignment;
//   final EdgeInsetsGeometry? padding;
//   final EdgeInsetsGeometry? margin;
//   final Color? backgroundColor;

//   @override
//   Widget build(BuildContext context) {
//     EdgeInsets safeMargin;

//     if (context.width > context.height) {
//       double width = (context.width - context.height) / 2 + 30;
//       safeMargin = EdgeInsets.fromLTRB(width, 0, width, 20);
//     } else {
//       safeMargin = const EdgeInsets.fromLTRB(30, 0, 30, 20);
//     }

//     return Container(
//       padding: padding ?? const EdgeInsets.fromLTRB(20, 35, 20, 15),
//       margin: margin ?? safeMargin,
//       decoration: BoxDecoration(
//         color: backgroundColor ?? AppThemeStyle.darkGrey,
//         borderRadius: AppThemeStyle.largeBorderRadius,
//         boxShadow: boxShadow ?? [],
//       ),
//       child: Flex(
//         crossAxisAlignment: crossAxisAlignment,
//         mainAxisAlignment: mainAxisAlignment,
//         mainAxisSize: MainAxisSize.min,
//         direction: direction,
//         children: children,
//       ),
//     );
//   }
// }
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// BottomSheet外框样式
class AppBottomSheetBox extends StatelessWidget {
  const AppBottomSheetBox({
    Key? key,
    this.children = const <Widget>[],
    this.boxShadow,
    this.backgroundColor,
    required this.title,
    this.message,
    this.confirmTitle,
    this.confirmBorderColor,
    this.confirmTextColor,
    required this.confirmOnTap,
    this.cancelBorderColor,
    this.cancelTextColor,
    this.cancelTitle,
    this.cancelOnTap,
  }) : super(key: key);

  final String title;
  final String? message;
  final List<Widget> children; // 自定义组件
  final List<BoxShadow>? boxShadow;
  final Color? backgroundColor;

  /// 确认按钮
  final Color? confirmBorderColor;
  final Color? confirmTextColor;
  final String? confirmTitle;
  final Function() confirmOnTap;

  /// 取消按钮
  final Color? cancelBorderColor;
  final Color? cancelTextColor;
  final String? cancelTitle;
  final Function()? cancelOnTap;

  @override
  Widget build(BuildContext context) {
    EdgeInsets safeMargin;

    if (context.width > context.height) {
      double width = (context.width - context.height) / 2 + 40;
      safeMargin = EdgeInsets.fromLTRB(width, 0, width, 20);
    } else {
      safeMargin = const EdgeInsets.fromLTRB(30, 0, 30, 20);
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      margin: safeMargin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppThemeStyle.darkGrey,
        borderRadius: AppThemeStyle.largeBorderRadius,
        boxShadow: boxShadow ?? [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 标题
          Text(
            title,
            style: Theme.of(Get.context!).textTheme.bodyText1,
          ),
          // 内容
          Visibility(
            visible: message == null ? false : true,
            child: Text(
              message ?? '',
              style: Theme.of(Get.context!)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.normal),
            ).marginOnly(top: 15),
          ),
          // 自定义组件
          Visibility(
            visible: children.isEmpty ? false : true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ).marginSymmetric(vertical: 25),
          ),

          // 确认按钮
          FeedbackButton(
            onTap: confirmOnTap,
            child: Container(
              width: 180,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: confirmBorderColor ?? Colors.transparent,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  confirmTitle ?? 'Confirm'.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
                        color: confirmTextColor ?? AppThemeStyle.white,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
          ).marginOnly(bottom: 20),

          /// 取消按钮
          FeedbackButton(
            onTap: cancelOnTap ?? () => Get.back(),
            child: Container(
              width: 175,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: cancelBorderColor ?? Colors.transparent,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  cancelTitle ?? 'Cancel'.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.bodyText1!.copyWith(
                        color: confirmTextColor ?? AppThemeStyle.white,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
