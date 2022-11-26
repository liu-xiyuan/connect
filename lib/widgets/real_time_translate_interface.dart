import 'package:connect/common/get_notification.dart';
import 'package:connect/controller/services/ml_speech_controller.dart';
import 'package:connect/controller/services/ml_translator_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:siri_wave/siri_wave.dart';

/// 实时翻译页面
///
/// 显示：Get.bottomSheet(RealTimeTranslateInterface())
class RealTimeTranslateInterface extends GetView<MlTranslatorController> {
  const RealTimeTranslateInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MlSpeechController>(
      initState: (_) => controller.startRealTimeTranslate(),
      dispose: (_) => controller.closeRealTimeTranslate(),
      builder: (_) => Obx(
        () => InkWell(
          onDoubleTap: () => GetNotification.closeBottomSheet(),
          child: GlassContainer.clearGlass(
            height: context.height,
            width: context.width,
            blur: 5,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(.3), Colors.black],
              stops: const [0, .4],
            ),
            borderWidth: 0,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // 背景渐变
                Positioned(
                  right: 30,
                  bottom: 15,
                  child: Text(
                    '*Double-click to stop translation',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: AppThemeStyle.clearGrey),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// 目标语言
                    Text(
                      controller.liveCaptionList[1].value,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 40),
                    ),

                    const SizedBox(height: 15),

                    /// 源语言
                    Text(
                      controller.liveCaptionList[0].value,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppThemeStyle.clearGrey,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ).paddingSymmetric(vertical: 30, horizontal: 35),

                // SiriWave
                Positioned(
                  bottom: -30,
                  child: SiriWave(
                    controller: controller.siriWaveControlle,
                    options: const SiriWaveOptions(
                      height: 180,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                //   margin: const EdgeInsets.only(left: 35, right: 35, bottom: 90),
                //   padding: const EdgeInsets.only(top: 20, bottom: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
