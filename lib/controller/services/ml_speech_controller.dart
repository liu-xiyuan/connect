import 'dart:developer';
import 'package:connect/common/permission_checker.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/model/tcp_call.dart';
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

  late SharedPreferences prefs;

  /// 语音波形控制器
  final siriWaveControlle = SiriWaveController(amplitude: 1, speed: .1);

  /// 语音识别转换的文字
  var speechText = ''.obs;

  var recognizer = MLAsrRecognizer();

  var recognizerStatus = SpeechStatus.running.obs;

  /// 命令模式列表
  List<String> commandModeList = ['Input Mode'];

  /// 当前命令模式索引值
  var commandModeIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    setHmsApiKey();
  }

  /// 设置HMS apiKey
  void setHmsApiKey() async {
    String api = prefs.getString('HMSApiKey') ?? '';

    if (api == '') {
      try {
        api = await rootBundle.loadString('assets/HMS_ApiKey.txt');
        prefs.setString('HMSApiKey', api);
      } catch (e) {
        log('$e');
      }
    }
    MLLanguageApp().setApiKey(api);
  }

  /// 切换语音识别服务
  void changeMode(int index) {
    commandModeIndex.value = index;
    if (index == 0) {
      speechText.value = 'Hi, Can I help you ?';
    }
  }

  /// 开始语音识别
  Future<void> startSpeechRecognition() async {
    // 每次使用语音识别前调用一次, 防止出现未设置key的BUG
    setHmsApiKey();

    recognizerStatus.value = SpeechStatus.running;

    /// 当录音机开始接收语音时被调用。
    void onStartListening() {
      // 播放开始识别的音频
      FlutterRingtonePlayer.play(
        fromAsset: "assets/audios/notification_incall.aac",
      );
      speechText.value = 'Hi, Can I help you ?';
    }

    // 识别结果
    void onRecognizingResults(String result) {
      speechText.value = result;
      log('onRecognizingResults:[$result]');
    }

    // 最终识别结果
    void onResults(String result) {
      if (recognizerStatus.value == SpeechStatus.running) {
        if (result != '') {
          speechText.value = result;
          switch (commandModeList[commandModeIndex.value]) {
            case 'Input Mode':
              TcpServiceController.to.sendData(
                TcpCommands.speechAction,
                SpeechAction.inputText,
                data: result,
              );
              break;
            default:
          }
        }

        log('onResults:[$result]');
      }
      stopSpeechRecognition();
    }

    void onError(int error, String errorMessage) {
      log('onError: $error | errorMessage: $errorMessage');
    }

    ///  state = 1: 启动语音识别服务
    ///  state = 2: 未识别到用户语音
    ///  state = 3: 未识别到用户语音_超时 自动执行onResults()
    ///  state = 7: 无网络连接
    void onState(int state) {
      log('onState: $state');
      switch (state) {
        case 2:
          speechText.value = 'Sorry I can\'t hear clearly';
          break;
        case 3:
          // 这个方法在onResults()前调用
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

  /// 显示语音识别页面
  Future<void> showSpeechInterface() async {
    if (Get.isBottomSheetOpen ?? false) Get.back();

    // 检查权限
    if (await PermissionChecker.checkSpeechPermissions()) {
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
