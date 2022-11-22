import 'dart:developer';
import 'package:connect/controller/services/permission_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/widgets/speech_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:huawei_ml_language/huawei_ml_language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siri_wave/siri_wave.dart';

/// 语音识别服务
class MlSpeechController extends GetxController {
  static MlSpeechController get to => Get.find();

  /// 语音波形控制器
  final siriWaveControlle = SiriWaveController();

  /// 语音识别转换的文字
  final speechText = ''.obs;

  String hmsApiKey = '';

  MLAsrRecognizer recognizer = MLAsrRecognizer();

  var recognizerStatus = SpeechStatus.running.obs;

  late SharedPreferences prefs;

  /// 命令模式列表
  List<String> commandModeList = [
    'Default Mode',
    'Input Mode',
  ];

  /// 当前命令模式索引值
  var commandModeIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    setApiKey();
    siriWaveControlle.setAmplitude(1);
    siriWaveControlle.setSpeed(.1);
  }

  /// 设置APP的HMS ML apiKey
  void setApiKey() async {
    hmsApiKey = prefs.getString('HMSApiKey') ?? '';

    if (hmsApiKey == '') {
      try {
        hmsApiKey = await rootBundle.loadString('assets/HMS_ApiKey.txt');
        prefs.setString('HMSApiKey', hmsApiKey);
        log('Set HMS ApiKey: $hmsApiKey');
      } catch (e) {
        log('$e');
      }
    }
    MLLanguageApp().setApiKey(hmsApiKey);
  }

  /// 开始语音识别
  Future<void> startSpeechRecognition() async {
    // 每次使用语音识别前调用一次, 防止出现未设置key的BUG
    setApiKey();

    recognizerStatus.value = SpeechStatus.running;

    /// 当录音机开始接收语音时被调用。
    void onStartListening() {
      // 播放开始识别的音频
      FlutterRingtonePlayer.play(
        fromAsset: "assets/audios/notification_incall.aac",
      );
      speechText.value = 'Hi, Can I help you?';
    }

    // 识别结果
    void onRecognizingResults(String result) {
      speechText.value = result;
      log('onRecognizingResults: $result');
    }

    // 最终识别结果
    void onResults(String result) {
      if (recognizerStatus.value == SpeechStatus.running) {
        if (result != '') {
          speechText.value = result;
        } else {
          speechText.value = 'Sorry I didn\'t catch that.';
        }
        sendSpeechResult(result);

        log('onResults: $result');
      }
    }

    void onError(int error, String errorMessage) {
      log('onError: $error | errorMessage: $errorMessage');
    }

    ///  应程序状态码
    ///  state = 1: 启动语音识别服务
    ///  state = 2: 未识别到用户语音
    ///  state = 3: 未识别到用户语音_超时 自动执行onResults()
    ///  state = 7: 无网络连接
    void onState(int state) {
      log('onState: $state');
      switch (state) {
        case 1:
          break;
        case 2:
          speechText.value = 'Sorry I didn\'t catch that.';
          break;
        case 3:
          // 这个方法在onResults()前调用
          stopSpeechRecognition(); // 一段时间里内没有监听到语音输入自动关闭
          break;
        case 7:
          speechText.value = '没有网络连接';
          break;
        default:
      }
    }

    // 设置监听器来跟踪事件。
    recognizer.setAsrListener(
      MLAsrListener(
        onStartListening: onStartListening,
        onRecognizingResults: onRecognizingResults,
        onResults: onResults,
        onError: onError,
        onState: onState,
      ),
    );

    // 创建一个 MLAsrSetting 对象来配置识别。
    final setting = MLAsrSetting(
      scene: MLAsrConstants.SCENES_SHOPPING,
      language: MLAsrConstants.LAN_ZH_CN,
      feature: MLAsrConstants.FEATURE_WORDFLUX,
    );
    recognizer.startRecognizing(setting);
  }

  /// 将语音识别文本通过TCP发送至电脑
  Future<void> sendSpeechResult(String data) async {
    stopSpeechRecognition();
    switch (commandModeList[commandModeIndex.value]) {
      case 'Default Mode':
        if (data.startsWith('输入')) {
          TcpServiceController.to.sendData(
            TcpCommands.speechAction,
            SpeechAction.inputText,
            data: data.split('输入')[1],
          );
        } else if (data == '锁屏') {
          TcpServiceController.to.sendData(
            TcpCommands.otherAction,
            OtherAction.lockScreen,
          );
        } else if (data == '复制') {
          TcpServiceController.to.sendData(
            TcpCommands.otherAction,
            OtherAction.copyText,
          );
        }
        break;
      case 'Input Mode':
        TcpServiceController.to.sendData(
          TcpCommands.speechAction,
          SpeechAction.inputText,
          data: data,
        );
        break;
      default:
    }
  }

  /// 显示语音识别页面
  Future<void> showSpeechInterface() async {
    if (Get.isBottomSheetOpen ?? false) Get.back();

    // 检查权限
    if (await PermissionController.to.checkSpeechPermissions()) {
      Get.bottomSheet(
        const SpeechFaceInterface(),
        enableDrag: false,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        enterBottomSheetDuration: const Duration(),
        exitBottomSheetDuration: const Duration(),
      );
    }
  }

  /// 停止语音识别
  void stopSpeechRecognition() {
    // 识别结束后销毁识别器
    if (recognizerStatus.value != SpeechStatus.closed) {
      recognizer.destroy();
    }
    recognizerStatus.value = SpeechStatus.closed;
    log('SpeechRecognitionStop');
  }

  @override
  void onClose() {
    super.onClose();
    stopSpeechRecognition();
  }
}

// 语音识别器状态
enum SpeechStatus { closed, running }
