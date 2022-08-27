import 'package:flutter/material.dart';

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
  }) : super(key: key);

  final List<Widget> children;
  final List<BoxShadow>? boxShadow;
  final Axis direction;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.fromLTRB(25, 30, 25, 20),
      margin: margin ?? const EdgeInsets.fromLTRB(30, 0, 30, 25),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
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
