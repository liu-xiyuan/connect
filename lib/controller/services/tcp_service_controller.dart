import 'dart:async';
import 'dart:developer';
import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/lab/shutdown_controller.dart';
import 'package:connect/controller/services/ml_face_controller.dart';
import 'package:connect/controller/services/ml_translator_controller.dart';
import 'package:connect/controller/text_field_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/app_text_field.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcp_client_dart/tcp_client_dart.dart';

/// TCP服务
class TcpServiceController extends GetxController {
  static TcpServiceController get to => Get.find();

  TcpClient? tcpClient;

  RxString ipAddress = "".obs;
  late String host;
  late int port;

  late SharedPreferences prefs;

  /// TCP连接状态
  var tcpSocketState = TcpConnectionState.disconnected.obs;

  /// 心跳计时器
  Timer? heartbeatTimer;

  /// 心跳检查
  var isHeartbeatAlive = false;

  /// 翻译功能节流指示器
  var translatorCount = 0.obs;

  @override
  void onInit() async {
    await initIPaddress();
    connect();
    super.onInit();
  }

  /// 初始化ip地址
  Future initIPaddress() async {
    prefs = await SharedPreferences.getInstance();
    host = prefs.getString('host') ?? '192.168.0.100';
    port = prefs.getInt('port') ?? 8888;
    ipAddress.value = '$host:$port';
  }

  /// 更新ip地址
  void updateIpAddress() async {
    List data = TextFieldController.to.editController.text.split(':');
    TcpServiceController.to.host = data[0];
    TcpServiceController.to.port = int.parse(data[1]);
    ipAddress.value = TextFieldController.to.editController.text;

    // 持久化保存
    await prefs.setString('host', data[0]);
    await prefs.setInt('port', int.parse(data[1]));
  }

  /// 显示IP地址编辑框
  void showIPEditSheet({
    bool isSavedConnect = false, // 是否保存并连接
  }) {
    GetNotification.showCustomBottomSheet(
      title: 'Set IP address',
      confirmTitle: isSavedConnect ? "Save & Connect" : "Save",
      confirmBorderColor: AppThemeStyle.clearGrey,
      confirmOnTap: () {
        updateIpAddress();
        Get.back();
        if (isSavedConnect) {
          connect();
        }
      },
      cancelOnTap: () => Get.back(),
      children: [
        AppTextField(
          initText: ipAddress.value,
          hintText: 'Input: 192.127.0.106:8888',
        ).marginSymmetric(vertical: 20),
      ],
    );
  }

  /// 显示锁屏密码设置框
  void showLockPwsEditSheet() {
    String res = prefs.getString('lockPwd') ?? '';
    GetNotification.showCustomBottomSheet(
      title: 'Set lock screen password',
      confirmBorderColor: AppThemeStyle.clearGrey,
      confirmOnTap: () async {
        res = TextFieldController.to.editController.text;
        Get.back();
        await prefs.setString('lockPwd', res);
      },
      cancelOnTap: () => Get.back(),
      children: [
        const AppTextField(
          hintText: 'Input your password',
        ).marginSymmetric(vertical: 20),
      ],
    );
  }

  /// 连接到pc服务端
  void connect() async {
    tcpClient?.close();
    heartbeatTimer?.cancel();

    TcpClient.debug = false; // 是否开启debug模式

    try {
      tcpClient = await TcpClient.connect(host, port); // 连接到pc服务端
    } catch (e) {
      // // 判断连接是否超时
      if (e.toString().contains('Connection timed out')) {
        GetNotification.showCustomSnackbar(
          'TCP connection timeout',
          'Check IP address and PC server',
          tipsIcon: FontAwesomeIcons.server,
          tipsIconColor: AppThemeStyle.red,
        );
      }
      log('TCP连接超时:[$e]');
      return;
    }

    tcpClient?.connectionStream.listen(statusListener);
    tcpClient?.stringStream.listen(stringStreamListener);
  }

  /// 监听TCP的连接状态
  void statusListener(TcpConnectionState status) {
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
          GetNotification.showCustomSnackbar(
            'TCP connected',
            'TCP is already connected',
            tipsIcon: FontAwesomeIcons.server,
            tipsIconColor: AppThemeStyle.green,
          );

          // 启动心跳服务
          heartbeatSocket();

          log('TCP连接成功!');
        }
        break;
      case TcpConnectionState.disconnected: // 连接关闭
        {
          GetNotification.showCustomSnackbar(
            'TCP disconnected',
            'Disconnected for unknown reasons',
            tipsIcon: FontAwesomeIcons.plugCircleXmark,
            tipsIconColor: AppThemeStyle.red,
          );
          log('TCP连接关闭!');
        }
        break;
      case TcpConnectionState.failed: // 连接失败
        {
          GetNotification.showCustomSnackbar(
            'TCP connection failed',
            'Check IP address and PC server',
            tipsIcon: FontAwesomeIcons.server,
            tipsIconColor: AppThemeStyle.red,
          );
          log('TCP连接失败!');
        }
        break;
      default:
    }
  }

  /// 监听从服务器端返回的数据
  void stringStreamListener(String data) {
    if (data == 'Heartbeat') {
      isHeartbeatAlive = true;
    } else if (data == 'Locked screen') {
      MlFaceController.to.isLockScreen = true;
      MlFaceController.to.unlockComputer();
    } else if (data == 'No lock screen') {
      MlFaceController.to.isLockScreen = false;
    } else if (data.startsWith('copyText:')) {
      String text = data.split('copyText:')[1];
      Clipboard.setData(ClipboardData(text: text));
      GetNotification.showCustomSnackbar(
        'Text Copy',
        'Text has been copied to the clipboard',
        tipsIcon: FontAwesomeIcons.solidClone,
        tipsIconColor: AppThemeStyle.green,
      );
    } else if (data.startsWith('shutdown')) {
      ShutdownController.to.listener(data);
    } else if (data.startsWith('Translate:')) {
      String source = data.split('Translate:')[1];
      MlTranslatorController.to.showTextTranslate(source);
    }
    log('服务端消息:[$data]');
  }

  /// 心跳服务
  void heartbeatSocket() {
    /// 每10秒向服务端发送一次心跳
    const timeInterval = Duration(seconds: 10);

    heartbeatTimer = Timer.periodic(timeInterval, (timer) async {
      if (!isHeartbeatAlive) {
        tcpSocketState.value = TcpConnectionState.disconnected;
        connect();
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
      // 尝试重新连接并发送数据
      connect();
      try {
        tcpClient!.send(dataText);
        log('重新发送消息:[$dataText]');
        return true;
      } catch (e) {
        log('消息发送失败!');
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

  /// 定时关机
  timedShutdown,

  /// 复制翻译的目标文本至电脑端剪贴板
  copyTranslator
}
