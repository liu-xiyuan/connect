import 'package:connect/controller/home_controller.dart';
import 'package:connect/widgets/app_test_button.dart';
import 'package:connect/widgets/home_page_appbar.dart';
import 'package:connect/widgets/touchbar.dart';
import 'package:connect/widgets/touchpad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      // 设置AppBar的高度为0
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: Obx(
        () => AnimatedSlide(
          offset: Offset(controller.homePageOffestX.value, 0),
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              // 背景渐变
              Obx(
                () => Image.asset(
                  "assets/images/img_home_bg.jpg",
                  height: context.height,
                  width: context.width * 2,
                  fit: BoxFit.cover,
                  alignment: Alignment(
                    controller.imageOffestX.value,
                    -1,
                  ),
                ),
              ),

              // 玻璃模糊效果
              GlassContainer.clearGlass(
                height: double.infinity,
                width: double.infinity,
              ),

              const Touchpad(),

              const Positioned(bottom: 0, child: Touchbar()),

              // 顶部导航栏
              const HomePageAppbar(),
            ],
          ),
        ),
      ),

      /// 测试按钮
      floatingActionButton: const AppTestButton(),
    );
  }
}
