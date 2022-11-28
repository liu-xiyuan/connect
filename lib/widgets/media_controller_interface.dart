import 'package:connect/common/color_util.dart';
import 'package:connect/controller/media_controller.dart';
import 'package:connect/controller/services/bluetooth_controller.dart';
import 'package:connect/controller/services/tcp_service_controller.dart';
import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';

class MediaInterface extends GetView<MediaController> {
  const MediaInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MediaController());

    /// 基本图标样式
    Widget basicIcon(
      IconData icon, {
      Color? iconColor,
    }) {
      return FaIcon(
        icon,
        color: iconColor ?? Colors.black.withOpacity(.6),
        size: 28,
      );
    }

    /// 基本按钮
    Widget basicButton(
      Function() onTap,
      IconData icon, {
      Function(TapUpDetails)? onTapUp,
      Function()? onLongPress,
      Color? iconColor,
      Color? backgroundColor,
    }) {
      return FeedbackButton(
        onTap: onTap,
        onTapUp: onTapUp,
        onLongPress: onLongPress,
        enableVibrate: true,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppThemeStyle.clearGrey,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: basicIcon(
              icon,
              iconColor: iconColor,
            ),
          ),
        ),
      );
    }

    /// 条形按钮
    Widget barButton(
      Function() onTap, {
      Function(TapDownDetails e)? onTapDown,
      Function(TapUpDetails)? onTapUp,
      Axis direction = Axis.horizontal,
      Color? backgroundColor,
      List<Widget> children = const [],
    }) {
      return FeedbackButton(
        onTap: onTap,
        onTapUp: onTapUp,
        onTapDown: onTapDown,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppThemeStyle.clearGrey,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: direction == Axis.horizontal
                ? const EdgeInsets.symmetric(horizontal: 30)
                : const EdgeInsets.symmetric(vertical: 30),
            child: Flex(
              direction: direction,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      );
    }

    /// 分割条
    Widget strip() {
      return Container(
        width: 10,
        height: 1,
        color: AppThemeStyle.darkGrey.withOpacity(.3),
      );
    }

    return SizedBox(
      height: context.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 玻璃模糊效果
          // 点击背景关闭页面
          InkWell(
            onTap: () => Get.back(),
            child: GlassContainer.clearGlass(
              height: double.infinity,
              width: double.infinity,
              blur: 20,
              color: AppThemeStyle.darkGrey.withOpacity(.3),
              borderWidth: 0,
            ),
          ),

          // Media Controller标题
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Media Controller',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: AppThemeStyle.white.withOpacity(.6),
                      fontWeight: FontWeight.bold,
                    ),
              ).marginOnly(left: 35),
              Container(
                width: context.width / 2,
                color: Colors.transparent,
                child: StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: [
                    /// 其他
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: basicButton(
                        () => null,
                        FontAwesomeIcons.flickr,
                      ),
                    ),

                    /// 打开默认音乐播放器
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: basicButton(
                        () {
                          TcpServiceController.to.sendData(
                            TcpCommands.otherAction,
                            OtherAction.openApplication,
                            data: controller.launchPath.value,
                          );
                        },
                        FontAwesomeIcons.compactDisc,
                        onLongPress: () => controller.updataLaunchPath(),
                      ),
                    ),

                    /// 音量调节
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 3,
                      child: barButton(
                        () => null,
                        direction: Axis.vertical,
                        backgroundColor: Colors.white,
                        onTapUp: (e) {
                          double widgetHeight = context.height * .7;
                          double position = e.localPosition.dy;
                          if (position <= widgetHeight / 3) {
                            BluetoothController.to.mediaControl(
                              MediaControl.volumeUp,
                            );
                          } else if (position >= widgetHeight / 3 &&
                              position <= widgetHeight * 2 / 3) {
                            BluetoothController.to.mediaControl(
                              MediaControl.mute,
                            );
                            controller.muteSwitch.toggle();
                          } else {
                            BluetoothController.to.mediaControl(
                              MediaControl.volumeDown,
                            );
                          }
                          BluetoothController.to.mediaControl(
                            MediaControl.release,
                          );
                        },
                        children: [
                          basicIcon(FontAwesomeIcons.plus),
                          strip(),
                          Obx(
                            () => basicIcon(
                              FontAwesomeIcons.volumeXmark,
                              iconColor: controller.muteSwitch.value
                                  ? ColorUtil.hex('#f65e6b')
                                  : null,
                            ),
                          ),
                          strip(),
                          basicIcon(FontAwesomeIcons.minus),
                        ],
                      ),
                    ),

                    /// 播放器控制条
                    StaggeredGridTile.count(
                      crossAxisCellCount: 3,
                      mainAxisCellCount: 1,
                      child: barButton(
                        () => null,
                        onTapUp: (e) {
                          double widgetWith = context.height * .61;
                          double position = e.localPosition.dx;
                          if (position <= widgetWith / 3) {
                            BluetoothController.to.mediaControl(
                              MediaControl.previousTrack,
                            );
                          } else if (position >= widgetWith / 3 &&
                              position <= widgetWith * 2 / 3) {
                            BluetoothController.to.mediaControl(
                              MediaControl.playOrPause,
                            );
                          } else {
                            BluetoothController.to.mediaControl(
                              MediaControl.nextTrack,
                            );
                          }
                          BluetoothController.to.mediaControl(
                            MediaControl.release,
                          );
                        },
                        onTapDown: (e) {},
                        backgroundColor: Colors.white,
                        children: [
                          basicIcon(
                            FontAwesomeIcons.backwardStep,
                          ),
                          basicIcon(
                            FontAwesomeIcons.solidCircle,
                            iconColor: ColorUtil.hex('#f65e6b'),
                          ),
                          basicIcon(
                            FontAwesomeIcons.forwardStep,
                          ),
                        ],
                      ),
                    ),

                    /// 喜欢歌曲按钮
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: basicButton(
                        () {
                          TcpServiceController.to.sendData(
                              TcpCommands.keyboardAction,
                              KeyboardAction.pressKeys,
                              data: 'ctrl, alt, L');
                        },
                        FontAwesomeIcons.solidHeart,
                        backgroundColor: ColorUtil.hex('#e05163'),
                        iconColor: ColorUtil.hex('#ffdfad'),
                      ),
                    ),

                    /// 打开/关闭歌词
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: basicButton(
                        () {
                          TcpServiceController.to.sendData(
                            TcpCommands.keyboardAction,
                            KeyboardAction.pressKeys,
                            data: 'ctrl, alt, d',
                          );
                        },
                        FontAwesomeIcons.solidClosedCaptioning,
                      ),
                    ),

                    /// mini模式
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: basicButton(
                        () {
                          TcpServiceController.to.sendData(
                            TcpCommands.keyboardAction,
                            KeyboardAction.pressKeys,
                            data: 'ctrl, shift, m',
                          );
                        },
                        FontAwesomeIcons.minimize,
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 35, vertical: 10),
              ),
            ],
          ).marginOnly(top: 0),
          Positioned(
            bottom: 20,
            child: Text(
              '*Only for NetEase CloudMusic',
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: AppThemeStyle.white.withOpacity(.6),
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
