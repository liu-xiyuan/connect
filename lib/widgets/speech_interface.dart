import 'dart:developer';

import 'package:connect/controller/services/speech_recognition_controller.dart';
import 'package:connect/style/app_custom_icons.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siri_wave/siri_wave.dart';

/// 语音识别BottomSheet
/// 使用Get.bottomSheet(SpeechFaceInterface())调用
class SpeechFaceInterface extends GetView<SpeechRecognitionController> {
  const SpeechFaceInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpeechRecognitionController>(
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
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(.5),
                      ],
                    ),
                  ),
                ),
              ),

              // SiriWave
              Positioned(
                bottom: -20,
                child: AnimatedScale(
                  scale: controller.recognizerStatus.value ==
                          SpeechRecognizerStatus.closed
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
                margin: const EdgeInsets.only(bottom: 115),
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //语音转换的文字
                    Text(
                      controller.speechText.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ).marginOnly(left: 20, bottom: 20),

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
                                  color:
                                      controller.commandModeIndex.value == index
                                          ? Colors.white.withOpacity(.4)
                                          : Colors.grey.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    controller.commandModeList[index],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ).marginOnly(left: index == 0 ? 20 : 5, right: 5),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 语音识别按钮
              Positioned(
                bottom: 40,
                child: AnimatedScale(
                  scale: controller.recognizerStatus.value ==
                          SpeechRecognizerStatus.closed
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
