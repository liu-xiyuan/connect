import 'dart:developer';

import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/permission_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/real_time_translate_interface.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:huawei_ml_language/huawei_ml_language.dart';
import 'package:siri_wave/siri_wave.dart';

/// 翻译服务
class MlTranslatorController extends GetxController {
  static MlTranslatorController get to => Get.find();

  /// 本地翻译服务 - 目前仅Debug模式有效
  MLLocalTranslator localTranslator = MLLocalTranslator();

  /// 是否正在进行本地翻译
  var isInlocalTranslation = false;

  /// 云翻译服务
  MLRemoteTranslator remoteTranslator = MLRemoteTranslator();

  /// 实时翻译服务
  MLSpeechRealTimeTranscription transcription = MLSpeechRealTimeTranscription();

  /// 实时翻译字幕
  var liveCaptionList = ["Translator!".obs, "[聆听中..]".obs].obs;

  /// 语言检测
  MLLangDetector detector = MLLangDetector();

  /// 语音波形控制器
  final siriWaveControlle = SiriWaveController(amplitude: 1, speed: .1);

  /// 检查源文本语言编码
  ///
  /// sourceLangCode: [res]['source'] | targetLangCode: [res]['target']
  Future<Map> checkLangCode(String source) async {
    String sourceLangCode;

    final setting = MLLangDetectorSetting.create(
      sourceText: source,
      isRemote: false, // 是否使用云服务检测
    );

    sourceLangCode = await detector.firstBestDetect(setting: setting) ?? 'zh';
    await detector.stop();

    Map<String, String> res = {
      'source': sourceLangCode,
      'target': sourceLangCode == 'zh' ? 'en' : 'zh',
    };

    return res;
  }

  /// 本地翻译服务 - 仅在DeBug模式中有效
  Future<String> localTranslate(String source) async {
    String? res;

    Map langCode = await checkLangCode(source);

    final setting = MLTranslateSetting.local(
      sourceLangCode: langCode['source'],
      targetLangCode: langCode['target'],
    );

    if (!isInlocalTranslation) {
      if (await localTranslator.prepareModel(setting, null)) {
        isInlocalTranslation = true;

        res = await localTranslator.syncTranslate(source);

        isInlocalTranslation = !(await localTranslator.stop());
      }
    }

    return res ?? '[本地翻译服务错误!]';
  }

  /// 云翻译服务
  Future<String> remoteTranslate(String source) async {
    Map langCode = await checkLangCode(source);

    final setting = MLTranslateSetting.remote(
      sourceText: source,
      sourceLangCode: langCode['source'],
      targetLangCode: langCode['target'],
    );

    String? target = await remoteTranslator.asyncTranslate(setting);
    await remoteTranslator.stopTranslate();

    return target ?? "[云翻译服务错误!]";
  }

  /// 实时翻译!
  ///
  /// 因30分钟/月实时翻译额度限制，功能暂未开放
  void startRealTimeTranslate() async {
    liveCaptionList.value = ["Translator!".obs, "[功能暂未开放]".obs];

    return;

    // 配置参数
    final config = MLSpeechRealTimeTranscriptionConfig(
      language: MLSpeechRealTimeTranscriptionConfig.LAN_EN_US,
      punctuationEnabled: false,
      wordTimeOffsetEnabled: true,
      sentenceTimeOffsetEnabled: true,
    );
    void onError(int error, String errorMessage) {}

    void onResult(MLSpeechRealTimeTranscriptionResult result) async {
      if (result.sentenceOffset != null) {
        String source =
            result.sentenceOffset![result.sentenceOffset!.length - 1].text!;
        // String res = await localTextTranslate(source);
        String res = await remoteTranslate(source);
        res = res.replaceAll(RegExp(r'[\p{P}\p{S}]+', unicode: true), ' ');

        liveCaptionList.clear();

        liveCaptionList.add(source.obs);
        liveCaptionList.add(res.obs);

        log('源语言: $source');
        log('翻译: $res');
      }
    }

    // 设置监听器
    transcription.setRealTimeTranscriptionListener(
      MLSpeechRealTimeTranscriptionListener(
        onError: onError,
        onResult: onResult,
      ),
    );
    transcription.startRecognizing(config);
  }

  /// 关闭实时翻译
  void closeRealTimeTranslate() {
    try {
      // transcription.destroy();
    } catch (e) {
      log('ERROR : [$e]');
    }
  }

  /// 显示实时翻译页面
  void showRealTimeTranslate() async {
    if (await PermissionController.to.checkSpeechPermissions()) {
      Get.bottomSheet(
        const RealTimeTranslateInterface(),
        enableDrag: false,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        enterBottomSheetDuration: const Duration(),
        exitBottomSheetDuration: const Duration(),
      );
    }
  }

  /// 显示文本翻译Snackbar
  ///
  /// [isRemote] ture:使用云翻译服务 / flase:使用本地翻译服务
  void showTextTranslate(String source, {bool isRemote = true}) async {
    String target; // 目标语言

    if (source.length > 50) {
      GetNotification.showCustomSnackbar(
        'Translator',
        'The source text can\'t be longer than 50',
        tipsIcon: FontAwesomeIcons.language,
        tipsIconColor: AppThemeStyle.red,
      );
      return;
    } else if (isInlocalTranslation) {
      GetNotification.showCustomSnackbar(
        'Translator',
        'Translation in progress, please wait...',
        tipsIcon: FontAwesomeIcons.language,
        tipsIconColor: AppThemeStyle.red,
      );
      return;
    }

    if (isRemote) {
      target = await remoteTranslate(source);
    } else {
      target = await localTranslate(source);
    }

    GetNotification.showCustomSnackbar(
      '',
      '',
      borderRadius: 40,
      padding: const EdgeInsets.all(20),
      duration: const Duration(minutes: 1),
      onTap: (_) {
        Get.closeAllSnackbars();
        TcpServiceController.to.sendData(
          TcpCommands.otherAction,
          OtherAction.copyTranslator,
          data: target,
        );
      },
      titleWidget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.language,
                color: AppThemeStyle.white,
                size: 15,
              ).marginOnly(right: 10),
              Text(
                "Translator",
                style: Theme.of(Get.context!)
                    .textTheme
                    .caption!
                    .copyWith(color: AppThemeStyle.white, height: 1.1),
              ),
            ],
          ),
          // 源语言
          SizedBox(
            width: 200,
            child: Text(
              source,
              style: Theme.of(Get.context!).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: AppThemeStyle.clearGrey,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ).marginSymmetric(vertical: 10),

          // 目标语言
          SizedBox(
            child: Text(
              target,
              style: Theme.of(Get.context!).textTheme.headline2,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      messageWidget: Text(
        "* Click to Copy",
        textAlign: TextAlign.end,
        style: Theme.of(Get.context!)
            .textTheme
            .subtitle2!
            .copyWith(color: AppThemeStyle.clearGrey),
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
    closeRealTimeTranslate();
  }
}

// 简单识别是否包含中文
// if (RegExp("[\u4e00-\u9fa5]").hasMatch(source)) {
//   sourceLangCode = 'zh';
// } else {
//   sourceLangCode = 'en';
// }
