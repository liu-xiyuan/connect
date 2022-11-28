import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

/// 带有缩放反馈和震动的按钮
class FeedbackButton extends StatelessWidget {
  const FeedbackButton({
    Key? key,
    required this.onTap,
    required this.child,
    this.isZoom = true,
    this.enableVibrate = false,
    this.onTapDown,
    this.onTapUp,
    this.onLongPress,
  }) : super(key: key);

  final Widget child;
  final Function() onTap;
  final bool isZoom;
  final bool enableVibrate;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    var scale = 1.0.obs;

    return Obx(
      () => AnimatedScale(
        scale: isZoom ? scale.value : 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTapUp: (_) {
            scale.value = 1.0;
            if (enableVibrate) Vibrate.feedback(FeedbackType.success);

            onTap();
            if (onTapUp != null) onTapUp!(_);
          },
          onTapDown: onTapDown,
          onTapCancel: () => scale.value = 1,
          onPanDown: (_) => scale.value = 0.9,
          onPanEnd: (_) => scale.value = 1,
          onPanCancel: () => scale.value = 1,
          onLongPress: onLongPress,
          child: child,
        ),
      ),
    );
  }
}
