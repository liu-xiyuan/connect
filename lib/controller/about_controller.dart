import 'package:connect/style/app_theme_style.dart';
import 'package:connect/widgets/about_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutController extends GetxController {
  late PackageInfo packageInfo;

  var appName = ''.obs;
  var packageName = ''.obs;
  var version = ''.obs;
  var buildNumber = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    initPackageInfo();
  }

  /// 初始化App信息
  void initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();

    appName.value = packageInfo.appName;
    packageName.value = packageInfo.packageName;
    version.value = packageInfo.version;
    buildNumber.value = packageInfo.buildNumber;
    // log('appName:$appName | packageName:$packageName | version:$version | buildNumber:$buildNumber');
  }

  /// 访问Github主页
  void toGithubHome() {
    Uri url = Uri.parse("https://github.com/liuxiyuan-2022/connect");
    launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
  }

  /// 显示About Dialog页面
  void showAboutDialog() {
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      backgroundColor: AppThemeStyle.darkGrey,
      radius: 40,
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      content: const AboutDialog(),
    );
  }
}
