import 'dart:math' as math;

import 'package:connect/controller/gamepad_controller.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';

// 蓝牙HID手柄页面
class GamepadPage extends GetView<GamepadController> {
  const GamepadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(GamepadController());
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 背景图片
          Image.asset(
            "assets/images/img_gamepad.jpg",
            width: context.width,
            height: context.height,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -1),
          ),
          // 玻璃模糊效果
          GlassContainer.clearGlass(
            height: double.infinity,
            width: double.infinity,
          ),

          // // 设置列表
          // Positioned(
          //   top: 30,
          //   child: FeedbackButton(
          //     onTap: () => {},
          //     child: const FaIcon(
          //       FontAwesomeIcons.xbox,
          //       size: 40,
          //       // color: Colors.white,
          //     ),
          //   ),
          // ),

          // LT键
          Positioned(
            top: 30,
            left: 30,
            child: FeedbackButton(
              onTap: () {},
              enableVibrate: true,
              child: Transform.rotate(
                angle: -math.pi / 10,
                child: Container(
                  width: 140,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'LT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
