import 'package:connect/controller/services/ml_speech_controller.dart';
import 'package:connect/style/app_custom_icons.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siri_wave/siri_wave.dart';

/// 语音识别BottomSheet
/// 使用: Get.bottomSheet(SpeechFaceInterface())
class SpeechFaceInterface extends GetView<MlSpeechController> {
  const SpeechFaceInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MlSpeechController>(
      initState: (_) => controller.startSpeechRecognition(),
      dispose: (_) => controller.stopSpeechRecognition(),
      builder: (_) => Obx(
        () => SizedBox(
          height: context.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // 背景渐变
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  height: context.height,
                  width: context.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(.5), Colors.black],
                        stops: const [0, .6]),
                  ),
                ),
              ),

              // SiriWave
              Positioned(
                bottom: -30,
                child: AnimatedScale(
                  scale:
                      controller.recognizerStatus.value == SpeechStatus.closed
                          ? 0
                          : 1,
                  duration: const Duration(milliseconds: 200),
                  child: SiriWave(
                    controller: controller.siriWaveControlle,
                    options: const SiriWaveOptions(
                      height: 180,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: 35, bottom: 90),
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //语音转换的文字
                    Text(
                      controller.speechText.value,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 20),
                    ).marginOnly(bottom: 15),
                    // 命令模式列表
                    SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.commandModeList.length,
                        scrollDirection: Axis.horizontal,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          return Obx(
                            () => FeedbackButton(
                              onTap: () {
                                controller.commandModeIndex.value = index;
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: controller.commandModeIndex.value ==
                                          index
                                      ? AppThemeStyle.darkGrey
                                      : AppThemeStyle.darkGrey.withOpacity(.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    controller.commandModeList[index],
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              ),
                            ).marginOnly(right: 10),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 语音识别按钮
              Positioned(
                bottom: 30,
                child: AnimatedScale(
                  scale:
                      controller.recognizerStatus.value == SpeechStatus.closed
                          ? 1
                          : 0,
                  duration: const Duration(milliseconds: 200),
                  child: FeedbackButton(
                    onTap: () => controller.startSpeechRecognition(),
                    child: const Icon(
                      AppCustomIcons.waveformLine,
                      color: Colors.white,
                      size: 55,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
