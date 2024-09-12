import 'dart:async';
import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/model/tcp_call.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/timer_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 定时关机控制器
class ShutdownController extends GetxController {
  static ShutdownController get to => Get.find();

  late SharedPreferences prefs;

  /// 是否正在计时
  var isTiming = false.obs;

  /// 关机时间
  var shutdownData = DateTime.now().obs;

  var hour = 1.obs;
  var minute = 0.obs;

  /// 计时器
  Timer? timer;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    initInfo();
    initTimer();
  }

  /// 初始化
  void initInfo() {
    isTiming.value = prefs.getBool('shutdown_timing') ?? false;
    if (prefs.getStringList('shutdown_data') != null) {
      List<int> dataList = [];
      for (var i = 0; i < 2; i++) {
        dataList.add(int.parse(prefs.getStringList('shutdown_data')![i]));
      }
      shutdownData.value.add(Duration(
        hours: dataList[0],
        minutes: dataList[1],
      ));
    } else {
      shutdownData.value = DateTime.now();
    }
  }

  /// 初始化计时器
  void initTimer() {
    timer?.cancel();
    if (isTiming.value) {
      timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
        if (timer.isActive) {
          var dateTime = DateTime.now();
          if (shutdownData.value.hour == dateTime.hour &&
              shutdownData.value.minute == dateTime.minute) {
            isTiming.value = false;

            GetNotification.showCustomSnackbar(
              'Timed Shutdown',
              'Windows is closing',
              tipsIcon: FontAwesomeIcons.powerOff,
              tipsIconColor: AppThemeStyle.green,
            );
            timer.cancel();
            await prefs.setBool('shutdown_timing', isTiming.value);
          } else if (!isTiming.value) {
            timer.cancel();
          }
        }
      });
    }
  }

  void listener(String data) async {
    List dataList = data.split(',');
    switch (dataList[1]) {
      case 'start':
        if (dataList[2] == 'T') {
          GetNotification.showCustomSnackbar(
            'Timed Shutdown',
            'Windows will shutdown in ${hour.value == 0 ? '' : '${hour.value} hour'} ${minute.value == 0 ? '' : '${minute.value} minutes'} 💤',
            tipsIcon: FontAwesomeIcons.solidClock,
            tipsIconColor: AppThemeStyle.green,
          );
          shutdownData.value = DateTime.now()
              .add(Duration(hours: hour.value))
              .add(Duration(minutes: minute.value));
          await prefs.setStringList(
            'shutdown_data',
            [
              shutdownData.value.hour.toString(),
              shutdownData.value.minute.toString(),
            ],
          );
          isTiming.value = true;
          initTimer();
        } else {
          GetNotification.showCustomSnackbar(
            'Timed Shutdown',
            'Unknown error!',
            tipsIcon: FontAwesomeIcons.solidClock,
            tipsIconColor: AppThemeStyle.red,
          );
          isTiming.value = false;
        }
        break;
      case 'clear':
        if (dataList[2] == 'T') {
          GetNotification.showCustomSnackbar(
            'Timed Shutdown',
            'Timing has been cancelled',
            tipsIcon: FontAwesomeIcons.solidCircleCheck,
            tipsIconColor: AppThemeStyle.green,
          );
          isTiming.value = false;
        } else {
          GetNotification.showCustomSnackbar(
            'Timed Shutdown',
            'Cannot cancel timer, Try again',
            tipsIcon: FontAwesomeIcons.solidClock,
            tipsIconColor: AppThemeStyle.red,
          );
        }
        break;
      default:
    }
    await prefs.setBool('shutdown_timing', isTiming.value);
  }

  ///  显示计时器编辑框 <修改时间>
  void showEditTimeBottomSheet() {
    if (isTiming.value) {
      cancelShutdown();
    } else {
      GetNotification.showCustomBottomSheet(
        title: 'Set Timer',
        confirmOnTap: () {
          Get.back();
          TcpServiceController.to.sendData(
            TcpCommands.otherAction,
            OtherAction.timedShutdown,
            data: '${hour.value},${minute.value}',
          );
        },
        confirmBorderColor: AppThemeStyle.white.withOpacity(.2),
        enableDrag: false,
        children: [
          TimerPicker(
            hourValue: hour,
            minuteValue: minute,
            scale: .8,
          ),
        ],
      );
    }
  }

  /// 取消定时关机
  void cancelShutdown() {
    GetNotification.showCustomBottomSheet(
      title: 'Cancel Timer Shutdown',
      message: 'Are you sure you want to cancel the timer?',
      confirmOnTap: () {
        Get.back();
        TcpServiceController.to.sendData(
          TcpCommands.otherAction,
          OtherAction.timedShutdown,
          data: "0,0",
        );
      },
      confirmBorderColor: Colors.transparent,
      cancelBorderColor: Colors.black,
    );
  }

  @override
  void onClose() {
    super.onClose();
    timer?.cancel();
  }
}
