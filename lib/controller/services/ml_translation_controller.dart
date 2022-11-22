import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/ml_speech_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:huawei_ml_language/huawei_ml_language.dart';

/// 文本翻译服务
class MlTranslatorController extends GetxController {
  static MlTranslatorController get to => Get.find();

  MLRemoteTranslator translator = MLRemoteTranslator();
  MLLangDetector detector = MLLangDetector();

  /// 检查源文本语言编码
  Future<Map> checkLangCode(String source) async {
    String sourceLangCode = 'zh';

    final setting = MLLangDetectorSetting.create(
      sourceText: source,
      isRemote: false, // 是否使用云服务检测
    );

    sourceLangCode = await detector.firstBestDetect(setting: setting) ?? 'zh';

    // 简单识别是否包含中文
    // if (RegExp("[\u4e00-\u9fa5]").hasMatch(source)) {
    //   sourceLangCode = 'zh';
    // } else {
    //   sourceLangCode = 'en';
    // }

    Map<String, String> res = {
      'source': sourceLangCode,
      'target': sourceLangCode == 'zh' ? 'en' : 'zh',
    };

    await detector.stop();
    return res;
  }

  /// 翻译！
  void showTranslate(String source) async {
    MlSpeechController.to.setApiKey();

    String? target; // 目标语言

    Map langCode = await checkLangCode(source);

    final setting = MLTranslateSetting.remote(
      sourceText: source,
      sourceLangCode: langCode['source'],
      targetLangCode: langCode['target'],
    );

    if (source.length > 50) {
      GetNotification.showCustomSnackbar(
        'Translator',
        'The source text can\'t be longer than 50',
        tipsIcon: FontAwesomeIcons.language,
        tipsIconColor: AppThemeStyle.red,
      );
      return;
    }

    target = await translator.asyncTranslate(setting);
    await translator.stopTranslate();

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
          data: target ?? "null",
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
              target ?? "翻译失败, 请重新尝试.",
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
}
