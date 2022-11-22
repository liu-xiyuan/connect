import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// BottomSheet外框样式
class AppBottomSheetBox extends StatelessWidget {
  const AppBottomSheetBox({
    Key? key,
    this.children = const <Widget>[],
    this.boxShadow,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.width,
  }) : super(key: key);

  final List<Widget> children;
  final double? width;
  final List<BoxShadow>? boxShadow;
  final Axis direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    EdgeInsets safeMargin;

    if (context.width > context.height) {
      double width = (context.width - context.height) / 2 + 30;
      safeMargin = EdgeInsets.fromLTRB(width, 0, width, 20);
    } else {
      safeMargin = const EdgeInsets.fromLTRB(30, 0, 30, 20);
    }

    return Container(
      padding: padding ?? const EdgeInsets.fromLTRB(20, 35, 20, 15),
      margin: margin ?? safeMargin,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppThemeStyle.darkGrey,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        boxShadow: boxShadow ?? [],
      ),
      child: Flex(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        direction: direction,
        children: children,
      ),
    );
  }
}
