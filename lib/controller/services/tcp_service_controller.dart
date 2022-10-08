import 'dart:async';
import 'dart:developer';
import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/face_verification_controller.dart';
import 'package:connect/style/color_palette.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcp_client_dart/tcp_client_dart.dart';

class TcpServiceController extends GetxController {
  static TcpServiceController get to => Get.find();

  TcpClient? tcpClient;
  late String host;
  late int port;

  late SharedPreferences prefs;

  /// TCP连接状态
  var tcpSocketState = TcpConnectionState.disconnected.obs;

  /// 心跳计时器
  Timer? heartbeatTimer;

  /// 心跳检查
  var isHeartbeatAlive = false;

  @override
  void onReady() async {
    super.onReady();
    await initIPaddress();
    connectToPCserver();
  }

  /// 初始化ip地址
  Future initIPaddress() async {
    prefs = await SharedPreferences.getInstance();
    host = prefs.getString('host') ?? '192.168.0.100';
    port = prefs.getInt('port') ?? 8888;
  }

  /// 连接到pc服务端
  void connectToPCserver() async {
    tcpClient?.close();
    heartbeatTimer?.cancel();

    // 是否开启debug模式
    TcpClient.debug = false;

    // 连接到pc服务端
    try {
      tcpClient = await TcpClient.connect(host, port);
    } catch (e) {
      // // 判断连接是否超时
      if (e.toString().contains('Connection timed out')) {
        GetNotification.showSnackbar(
          'TCP disconnected',
          'Check IP address and PC server',
          tipsIcon: FontAwesomeIcons.server,
          tipsIconColor: ColorPalette.red,
        );
      }
      log('TCP连接超时:[$e]');
      return;
    }

    /// 监听TCP连接状态
    tcpClient?.connectionStream.listen((status) {
      tcpSocketState.value = status;

      if (status == TcpConnectionState.connected) {
        isHeartbeatAlive = true;
      } else {
        isHeartbeatAlive = false;
      }

      switch (status) {
        case TcpConnectionState.connecting: // 连接中
          {
            log('TCP连接中...');
          }
          break;
        case TcpConnectionState.connected: // 已连接
          {
            GetNotification.showSnackbar(
              'TCP connected',
              'TCP is already connected',
              tipsIcon: FontAwesomeIcons.server,
              tipsIconColor: ColorPalette.green,
            );

            // 启动心跳服务
            heartbeatSocket();

            log('TCP连接成功!');
          }
          break;
        case TcpConnectionState.disconnected: // 连接关闭
          {
            GetNotification.showSnackbar(
              'TCP disconnected',
              'Check IP address and PC server',
              tipsIcon: FontAwesomeIcons.server,
              tipsIconColor: ColorPalette.red,
            );
            log('TCP连接关闭!');
          }
          break;
        case TcpConnectionState.failed: // 连接失败
          {
            GetNotification.showSnackbar(
              'TCP disconnected',
              'Check IP address and PC server',
              tipsIcon: FontAwesomeIcons.server,
              tipsIconColor: ColorPalette.red,
            );
            log('TCP连接失败!');
          }
          break;
        default:
      }
    });

    /// 监听接收的数据
    tcpClient?.stringStream.listen((data) {
      if (data == 'Heartbeat') {
        isHeartbeatAlive = true;
      } else if (data == 'Locked screen') {
        FaceVerificationController.to.isLockScreen = true;
        FaceVerificationController.to.unlockComputer();
      } else if (data == 'No lock screen') {
        FaceVerificationController.to.isLockScreen = false;
      } else if (data.startsWith('copyText:')) {
        String text = data.split('copyText:')[1];
        Clipboard.setData(ClipboardData(text: text));
        GetNotification.showSnackbar(
          'Text Copy',
          'Text has been copied to the clipboard',
          tipsIcon: FontAwesomeIcons.solidClone,
          tipsIconColor: ColorPalette.green,
        );
      }
      log('服务端消息:[$data]');
    });
  }

  /// 心跳服务
  void heartbeatSocket() {
    /// 每10秒向服务端发送一次心跳
    const timeInterval = Duration(seconds: 10);

    heartbeatTimer = Timer.periodic(timeInterval, (timer) async {
      if (!isHeartbeatAlive) {
        tcpSocketState.value = TcpConnectionState.disconnected;

        connectToPCserver();
      } else {
        sendData(TcpCommands.heartbeatAction, 'null');
      }
      isHeartbeatAlive = false;
    });
  }

  /// 向PC服务端发送消息, 并返回是否成功
  bool sendData(TcpCommands header, Object action, {String data = 'null'}) {
    String dataText = '$header,$action,$data';

    try {
      tcpClient!.send(dataText);
      log('发送消息:[$dataText]');
      return true;
    } catch (e) {
      // 尝试重新连接
      connectToPCserver();

      // 尝试重新发送数据
      try {
        tcpClient!.send(dataText);
        log('重新发送消息:[$dataText]');
        return true;
      } catch (e) {
        log('消息发送失败');
        return false;
      }
    }
  }

  /// 关闭TCP连接
  void closeConnection() {
    tcpClient?.close();
  }

  @override
  void onClose() {
    super.onClose();
    if (heartbeatTimer?.isActive ?? false) {
      heartbeatTimer?.cancel();
    }
  }
}

/// 向服务端发送的指令类别
enum TcpCommands {
  /// 鼠标操作
  mouseAction,

  /// 键盘操作
  keyboardAction,

  /// 语音操作
  speechAction,

  /// 其他
  otherAction,

  /// 心跳
  heartbeatAction,
}

/// 键盘事件
enum KeyboardAction {
  /// 按压组合键
  pressKeys,

  /// 网站缩放
  webpageZoom,
}

/// 语音事件
enum SpeechAction {
  /// 输入文字
  inputText,
}

/// 其他事件
enum OtherAction {
  /// 检查是否是锁屏页面
  checkLockScreen,

  /// 锁屏
  lockScreen,

  /// 复制文本到手机端
  copyText,

  /// 打开指定路径的应用
  openApplication,
}
