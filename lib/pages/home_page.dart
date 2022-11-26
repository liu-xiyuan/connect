import 'package:connect/controller/home_controller.dart';
import 'package:connect/widgets/app_test_button.dart';
import 'package:connect/widgets/home_page_appbar.dart';
import 'package:connect/widgets/simple_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          child: GestureDetector(
            // 左右滑动
            onHorizontalDragUpdate: (e) => controller.onHorizontalDragUpdate(e),
            onHorizontalDragEnd: (_) => controller.onHorizontalDragEnd(),

            // 上下滑动
            onVerticalDragUpdate: (e) => controller.onVerticalDragUpdate(e),
            onVerticalDragEnd: (_) => controller.onVerticalDragEnd(),

            // 长按移动
            onLongPressStart: (_) => controller.onLongPressStart(),
            onLongPressMoveUpdate: (e) => controller.onLongPressMoveUpdate(e),
            onLongPressEnd: (_) => controller.onLongPressEnd(),

            // 缩放手势
            // onScaleUpdate: (e) => controller.onScaleUpdate(e),
            // onScaleEnd: (_) => controller.onScaleEnd(),

            child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: const [
                  Center(child: SimpleDate()),
                  HomePageAppbar(),
                ],
              ),
            ),
          ),
        ),
      ),

      /// 测试按钮
      floatingActionButton: const AppTestButton(),
    );
  }
}
