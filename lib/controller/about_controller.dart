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
  void openGithubHome() {
    Uri url = Uri.parse("https://github.com/liuxiyuan-2022/connect");
    launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
  }

  void openHelp() {
    Uri url = Uri.parse(
      'https://github.com/liuxiyuan-2022/connect/blob/main/README.md#%E5%B8%AE%E5%8A%A9',
    );
    launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
  }
}
