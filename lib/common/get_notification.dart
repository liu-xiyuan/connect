import 'package:connect/widgets/app_bottomsheet_box.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class GetNotification {
  /// 关闭bottomSheet
  static void closeBottomSheet() {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }

  /// 显示自定义Toast
  static showToast({
    required String message,
  }) {
    FToast fToast = FToast();

    // 清除Toast
    fToast.removeQueuedCustomToasts();

    // 提供overlay的上下文
    fToast.init(Get.overlayContext!);

    fToast.showToast(
      toastDuration: const Duration(milliseconds: 2000),
      gravity: ToastGravity.TOP,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.1),
              blurRadius: 20,
            ),
          ],
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  /// 显示Snackbar基本通知
  static void showSnackbar(
    String title,
    String message, {
    IconData? tipsIcon,
    Color? tipsIconColor,
    double? tipsIconSize,
    SnackbarDuration duration = SnackbarDuration.short,
    bool isCleanQueue = true, // 是否关闭队列中的Snackbar
  }) {
    if (isCleanQueue) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      duration: duration == SnackbarDuration.short
          ? const Duration(seconds: 3)
          : const Duration(milliseconds: 4000),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      backgroundColor: Colors.grey.withOpacity(.1),
      isDismissible: false,
      onTap: (_) => Get.closeCurrentSnackbar(),
      snackbarStatus: (status) async {
        switch (status) {
          case SnackbarStatus.OPENING:
            // 播放音频
            FlutterRingtonePlayer.play(
              fromAsset: "assets/audios/notification_fresh.ogg",
            );
            break;
          case SnackbarStatus.CLOSED:
            // 关闭音频
            FlutterRingtonePlayer.stop();
            break;
          default:
        }
      },
      mainButton: TextButton(
        onPressed: null,
        child: FaIcon(
          tipsIcon,
          color: tipsIconColor ?? Colors.black,
          size: tipsIconSize ?? 25,
        ),
      ),
    );
  }

  /// 显示自定义的GetBottomSheet
  static Future<T?> showCustomBottomSheet<T>({
    required String title,
    String? message,
    String? confirmTitle,

    /// 确认按钮
    Color? confirmBorderColor,
    Color? confirmTextColor,
    required Function() confirmOnTap,

    /// 取消按钮
    Color? cancelTextColor,
    String? cancelTitle,
    required Function() cancelOnTap,

    /// 自定义组件
    List<Widget> children = const <Widget>[],

    /// 点击背景是否可以关闭
    bool? isDismissble,
  }) {
    return Get.bottomSheet(
      AppBottomSheetBox(
        children: [
          // 标题
          Text(
            title,
            style: Theme.of(Get.context!).textTheme.bodyText1,
          ).marginOnly(bottom: 15),
          // 内容
          Visibility(
            visible: message == null ? false : true,
            child: Text(
              message ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
          ),
          // 自定义组件
          Visibility(
            visible: children.isEmpty ? false : true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),

          // 确认按钮
          FeedbackButton(
            onTap: confirmOnTap,
            child: Container(
              width: 175,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: confirmBorderColor ??
                      Theme.of(Get.context!).toggleableActiveColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  confirmTitle ?? 'confirm'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: confirmTextColor ??
                        Theme.of(Get.context!).toggleableActiveColor,
                    fontSize: 16,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ).marginOnly(bottom: 5, top: 20),

          /// 取消按钮
          FeedbackButton(
            onTap: cancelOnTap,
            child: Container(
              width: 175,
              height: 50,
              color: Colors.transparent,
              child: Center(
                child: Text(
                  cancelTitle ?? 'cancel'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cancelTextColor ?? Colors.black,
                    fontSize: 16,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ignoreSafeArea: true,
      isScrollControlled: true, // 是否支持全屏弹出
      barrierColor: Colors.black12,
      isDismissible: isDismissble ?? true,
    );
  }
}

/// Snackbar的持续时间
///
/// [SnackbarDuration.short] : 显示持续3秒
/// [SnackbarDuration.long] : 显示持续4秒
enum SnackbarDuration { long, short }
