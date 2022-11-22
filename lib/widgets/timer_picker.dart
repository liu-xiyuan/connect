import 'package:connect/style/app_theme_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerPicker extends StatelessWidget {
  const TimerPicker({
    Key? key,
    required this.hourValue,
    required this.minuteValue,
    this.scale = 1,
  }) : super(key: key);

  // 需要改变的变量
  final RxInt hourValue;
  final RxInt minuteValue;

  final double scale;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context).copyWith(
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 40 * scale,
          color: AppThemeStyle.white,
          fontWeight: FontWeight.bold,
        ),

        // textStyle
        headline2: TextStyle(
          fontSize: 22 * scale,
          color: AppThemeStyle.clearGrey,
        ),

        // 时分秒文字
        subtitle1: TextStyle(
          fontSize: 20 * scale,
          fontWeight: FontWeight.w100,
          color: AppThemeStyle.white,
        ),
      ),
    );

    Widget line() {
      return Container(
        width: 10,
        height: 1,
        color: AppThemeStyle.clearGrey,
      ).marginSymmetric(horizontal: 10);
    }

    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              line(),
              // 小时
              NumberPicker(
                minValue: 0,
                maxValue: 10,
                zeroPad: true,
                itemWidth: 70 * scale,
                itemHeight: 50 * scale,
                value: hourValue.value,
                selectedTextStyle: theme.textTheme.headline1,
                textStyle: theme.textTheme.headline2,
                infiniteLoop: true,
                onChanged: (value) {
                  hourValue.value = value;
                },
              ),
              Text('H', style: theme.textTheme.subtitle1)
                  .marginOnly(right: 20 * scale),

              // 分钟
              NumberPicker(
                minValue: 0,
                maxValue: 59,
                zeroPad: true,
                itemWidth: 70 * scale,
                itemHeight: 50 * scale,
                value: minuteValue.value,
                selectedTextStyle: theme.textTheme.headline1,
                textStyle: theme.textTheme.headline2,
                infiniteLoop: true,
                onChanged: (value) {
                  minuteValue.value = value;
                },
              ),
              Text('M', style: theme.textTheme.subtitle1),
              line(),
            ],
          ),
        ],
      ),
    );
  }
}
